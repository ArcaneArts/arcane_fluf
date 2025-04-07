You can connect everything into everything pretty easily

```dart
// Run fluf app instead of run app
void main() => runFlufApp(
  // Connect app
  app: MyApp(),
  
  // Connect firebase options
  options: DefaultFirebaseOptions.currentPlatform,
  
  // Register crud here
  onRegisterCrud:
      () =>
          $crud..registerModel(
            FireModel<MyUser>(
              model: MyUser(),
              collection: "user",
              fromMap: (_) => MyUser(),
              toMap: (_) => {},
            ),
          ),
  
  // Register services here
  onRegisterServices:
      () => services()..register<UserService>(() => UserService()),
  setupMetaSEO: false,
  authAllowAnonymous: false,
  authAutoLink: true,
  authOnBind: svc<UserService>().bind,
  authOnUnbind: svc<UserService>().unbind,
  authSignInConfigs: [],
);

// Authenticated Arcane App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => AuthenticatedArcaneApp(
    home: Placeholder(),
    authMethods: [AuthMethod.emailPassword],
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
class UserService extends FlufUserService<MyUser, MyCapabilities, MySettings> {
  @override
  MyCapabilities createUserCapabilitiesModel(UserMeta meta) => MyCapabilities();

  @override
  MyUser createUserModel(UserMeta meta) => MyUser();

  @override
  MySettings createUserSettingsModel(UserMeta meta) => MySettings();
}
```