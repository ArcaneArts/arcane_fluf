You can connect everything into everything pretty easily

```dart
// Run fluf app instead of run app
void main() => runApp("my_app_id", ArcaneFluf(
  
  // Connect firebase options
  options: DefaultFirebaseOptions.currentPlatform,
  
  // register crud models
  onRegisterCrud: () => $crud..registerModel(
    FireModel<MyUser>(
      model: MyUser(),
      collection: "user",
      fromMap: (_) => MyUser(),
      toMap: (_) => {},
    ),
  ),
  
  // Connect our user service
  onRegisterUserService: () => services().register<UserService>(() => UserService()),
  child: const MyApp()
));

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
      onBind: (u) async => svc<UserService>().bind(u),
      onUnbind: () async => svc<UserService>().unbind(),
    )
  );
}

/// GENERIC USER MODELS
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

class MyCapabilities with ModelCrud {
  @override
  List<FireModel<ModelCrud>> get childModels => [];
}

class MySettings with ModelCrud {
  @override
  List<FireModel<ModelCrud>> get childModels => [];
}

/// CONNECT USER SERVICE
Stream<MyUser?> get $userStream => svc<UserService>().$userStream;
Stream<MySettings?> get $settingsStream => svc<UserService>().$settingsStream;
Stream<MyCapabilities?> get $capabilitiesStream =>
    svc<UserService>().$capabilitiesStream;
MyUser get $user => svc<UserService>().$user;
MySettings get $settings => svc<UserService>().$settings;
MyCapabilities get $capabilities => svc<UserService>().$capabilities;

// User service macro
class UserService extends ArcaneUserService<MyUser, MyCapabilities, MySettings> {
  @override
  MyCapabilities createUserCapabilitiesModel(UserMeta meta) => MyCapabilities();

  @override
  MyUser createUserModel(UserMeta meta) => MyUser();

  @override
  MySettings createUserSettingsModel(UserMeta meta) => MySettings();
}
```

For More info see [arcane_user](https://pb.dev/packages/arcane_user) for the user service, and [arcane_auth](https://pb.dev/packages/arcane_auth) for the authentication methods.