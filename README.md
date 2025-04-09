You can connect everything into everything pretty easily

# Setup
Setting up arcane_fluf is pretty simple, just add the package and prep your `main.dart` file, this setup guide assumes you are using [arcane](https://pub.dev/packages/arcane) and [arcane_user](https://pub.dev/packages/arcane_user) and [fire_crud](https://pub.dev/packages/fire_crud) for your models, and that you have a separate `your_models` package

## Setup User Models with FireCrud
The arcane bias is user, with a settings & capabilities model within, but you can do whatever you want.

#### Define the Capabilities Model
This represents stuff the user cant write to but can read

```dart
part 'user_capabilities.mapper.dart';

@MappableClass()
class MyCapabilities with ModelCrud {
  @override
  List<FireModel<ModelCrud>> get childModels => [];
}
```

#### Define the Settings Model
This represents stuff only the user can see and write to. For the FCM stuff [read hgere](https://pub.dev/packages/arcane_fcm_models)
```dart
part 'user_settings.mapper.dart';

@MappableClass()
class MySettings with ModelCrud {
  // Along with your other properties, add this field here
  @MappableField(hook: FCMDeviceHook()) // <-- This helps encode/decode with dart mappable
  final List<FCMDeviceInfo> devices;

  MySettings({
    ...,

    // Add devices to your constructor non-required
    this.devices = const [],
  });
  
  @override
  List<FireModel<ModelCrud>> get childModels => [];
}
```

#### Define the User model
```dart
part 'user.mapper.dart';

@MappableClass()
class MyUser with ModelCrud {
  @override
  List<FireModel<ModelCrud>> get childModels => [
    FireModel<MyCapabilities>(
      model: MyCapabilities(),
      collection: "data",
      exclusiveDocumentId: "capabilities",
      fromMap: (_) => MyCapabilities(),
      toMap: (_) => {},
    ),
    FireModel<MySettings>(
      model: MySettings(),
      collection: "data",
      exclusiveDocumentId: "settings",
      fromMap: (_) => MySettings(),
      toMap: (_) => {},
    ),
  ];
}
```

## Setup User Service
Now that we have our user models, we need to create a user service to manage the user and open streams for stuff

```dart
// User service macro
class MyUserService extends ArcaneUserService<MyUser, MyCapabilities, MySettings> {
  @override
  MyCapabilities createUserCapabilitiesModel(UserMeta meta) => MyCapabilities();

  @override
  MyUser createUserModel(UserMeta meta) => MyUser();

  @override
  MySettings createUserSettingsModel(UserMeta meta) => MySettings();

  // Tell the notification service when we sign out
  @override
  Future<void> onPreSignOut() => svc<MyNotificationService>().onSignOut();
  
  // Tell the notification service when we bind
  @override
  Future<void> onPostBind(U user) => svc<NotificationService>().onBind();
  
  // Tell the notification service when we unbind
  @override
  Future<void> onPostUnbind() => svc<NotificationService>().onUnbind();
}
```

You can add globals to make your life easier like so
```dart
Stream<MyUser?> get $userStream => svc<UserService>().$userStream;
Stream<MySettings?> get $settingsStream => svc<UserService>().$settingsStream;
Stream<MyCapabilities?> get $capabilitiesStream =>
    svc<UserService>().$capabilitiesStream;
MyUser get $user => svc<UserService>().$user;
MySettings get $settings => svc<UserService>().$settings;
MyCapabilities get $capabilities => svc<UserService>().$capabilities;
```

## Setup Notification Models
Now we need to create notification models [like so](https://pub.dev/packages/arcane_fcm_models)

#### Implement base notification model
```dart
part 'notification.mapper.dart';

@MappableClass(
  // Every time you add a new subclass notification model
  // You need to add it here so mappable knows about it
  includeSubClasses: [
    MyNotificationTaskReminder,
    // Add more subclass notifications here
  ],
  
  // This is so mappable knows what field to use to determine the subclass
  discriminatorKey: "ntype",
)

// You need to add the mixin ArcaneFCMMessage
class MyNotification with MyNotificationMappable, ArcaneFCMMessage {
  // ArcaneFCMMessage requires a user field since all notifications
  // Are delivered to a signed in user, this ensures only signed in 
  // users see their notifications
  @override
  final String user;

  // Add user to your constructor as required
  const MyNotification({required this.user});
}
```

#### Implement subclass notification models
```dart
part 'notification_task_reminder.mapper.dart';

@MappableClass(
    // This is the type name of our notification
    // So this would map to {"ntype": "task_reminder"}
    discriminatorValue: "task_reminder"
)
class MyNotificationTaskReminder extends MyNotification
    with MyNotificationTaskReminderMappable {
  
  // Add any desired fields here. The data here is ONLY the payload
  // No need to include a title / body. This is just the data we need
  // When a user opens a notification and the app needs to do something
  final String task;

  const MyNotificationTaskReminder({
    // Define the user superparameter
    required super.user,
    
    // Define our task parameter
    required this.task,
  });
}
```

## Setup Notification Service
You can see this [here](https://pub.dev/packages/arcane_fcm)

#### Implement the notification service
```dart
import 'package:arcane_fcm/arcane_fcm.dart';
import 'package:arcane_fcm_models/arcane_fcm_models.dart';

// Our service extends the arcane fcm service
// We need to bind it to our root notification model
class MyNotificationService extends ArcaneFCMService<MyNotification> {
  // We need to implement the notificationFromMap method
  // Just deserialize the notification
  @override
  MyNotification notificationFromMap(Map<String, dynamic> map) =>
      MyNotificationMapper.fromMap(map);

  @override
  Map<Type, ArcaneFCMHandler> onRegisterNotificationHandlers() => const {
    // Bind the notification type to the handler for it.
    // See implementation of handler below.
    MyNotificationTaskReminder: TaskReminderNotificationHandler()
  }

  // Here, we need to grab our user devices
  // Since were using arcane_fluf, our capabilities are streamed live so we can just grab
  @override
  Future<List<FCMDeviceInfo>> readUserDevices(String user) async =>
      $capabilities.devices;

  // Here we need to write our user devices
  @override
  Future<void> writeUserDevices(String user, List<FCMDeviceInfo> devices) =>
      $capabilities.setSelfAtomic<MyUserCapabilities>(
            (i) => i!.copyWith(devices: devices),
      );
}
```

#### Implement the notification handlers
```dart
// We need to extend ArcaneFCMHandler and bind it to our specific notification subclass we want to handle
class TaskReminderNotificationHandler
    extends ArcaneFCMHandler<MyNotificationTaskReminder> {
  // Add a const constructor so we only ever have one instance.
  const TaskReminderNotificationHandler();
  
  @override
  Future<void> handle(
    BuildContext context,
    MyNotificationTaskReminder notification,
  ) {
    // Do whatever when the user taps this notification
    // Here, we're using fire_crud to obtain the task reminder object based on the notification task id
    // Since its guaranteed that $user and $uid match notification.user, we can use $user.get
    TaskReminder? t = $user.get<TaskReminder>(notification.task);

    // Check if the task reminder isnt there
    if (t == null) {
      TextToast("Task not found").open(context);
      return;
    }

    // Otherwise open the task screen
    Sheet(
      builder:
          // Since were using pylon here, we add the task object we obtained to context
          (context) => Pylon<TaskReminder>(
            value: t!,
            // Then show the reminder screen!
            builder: (context) => TaskReminderScreen(),
          ),
    ).open(context);
  }
}
```

## Setup Authenticated App
We need an application finally. More info [here](https://pub.dev/packages/arcane_auth)
```dart
// Authenticated Arcane App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => AuthenticatedArcaneApp(
      home: Placeholder(), // Your home screen
      authConfig: AuthConfig(
        // Setup Auth methods
        authMethods: [AuthMethod.emailPassword],
        // Connect user service binding events
        onBind: (u) async => svc<MyUserService>().bind(u),
        onUnbind: () async => svc<MyUserService>().unbind(),
      )
  );
}
```

## Setup Main Init
This is in your main.dart
```dart
import 'package:arcane/arcane.dart';

void main() => runApp("my_app_id", ArcaneFluf(
  // Connect firebase options
  options: DefaultFirebaseOptions.currentPlatform,

  // register root crud models
  onRegisterCrud: () => $crud..registerModel(
    FireModel<MyUser>(
      model: MyUser(),
      collection: "user",
      fromMap: (_) => MyUser(),
      toMap: (_) => {},
    ),
  ),

  // Connect our user service
  onRegisterServices: (s) => s
    // Register our user service
    ..register<MyUserService>(() => MyUserService())
  
    // Register our notification service, make lazy false!
    ..register<MyNotificationService>(() => MyNotificationService(), lazy: false),
  child: const MyApp()
));
```

## Setup FCMRunner in screens
The FCM Runner needs to be in your app screens such that if a notification were tapped while on that screen, we have context available for a notification handler.

```dart
class MyScreen extends StatelessWidget {
  const MyScreen({super.key});
  
  @override
  // Wrap in FCMRunner
  Widget build(BuildContext context) => FCMRunner(ArcaneScreen(...));
}
```

## Setup Checklist
1. Make sure you have run flutterfire configure to get the default options
2. Make sure you generate your models with `flutter pub run build_runner build --delete-conflicting-outputs`
3. Make sure your user service connects its bind, unbind & signOut to the notification service
4. Make sure you have registered your user service & notification service
5. Make sure you have registered your notification handlers in the notification service