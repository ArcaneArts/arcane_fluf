library arcane_fluf;

import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:arcane_auth/arcane_auth.dart';
import 'package:fire_api_flutter/fire_api_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:serviced/serviced.dart';

late Box hotBox;
late LazyBox coldBox;

void runFlufApp({
  required Widget app,
  required FirebaseOptions options,
  required VoidCallback onRegisterCrud,
  required VoidCallback onRegisterServices,
  bool splashAutoremove = true,
  bool debugFirestoreLogging = false,
  bool debugFirestoreThrowOnGet = false,
  bool setupMetaSEO = true,
  bool authAllowAnonymous = false,
  Future<void> Function(UserMeta user)? authOnBind,
  Future<void> Function()? authOnUnbind,
  bool authAutoLink = true,
  List<SocialSignInSiteConfig> authSignInConfigs = const [],
}) async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  setupArcaneDebug();
  await Firebase.initializeApp(options: options);
  onRegisterCrud();
  FirebaseFirestoreDatabase.create()
    ..debugLogging = debugFirestoreLogging
    ..throwOnGet = debugFirestoreThrowOnGet;
  await _initHive(options.projectId);
  onRegisterServices();
  services(); // ..register()...
  await Future.wait([services().waitForStartup()]);
  initArcaneAuth(
    allowAnonymous: authAllowAnonymous,
    autoLink: authAutoLink,
    signInConfigs: authSignInConfigs,
    onBind: authOnBind,
    onUnbind: authOnUnbind,
  );

  if (splashAutoremove) {
    Future.delayed(
      Duration(milliseconds: 50),
      () => FlutterNativeSplash.remove(),
    );
  }

  runApp(app, setupMetaSEO: setupMetaSEO);
}

Future<void> _initHive(String name) async {
  await Hive.initFlutter(name);
  await Future.wait([
    Hive.openBox(
      "$name.hb",
      encryptionCipher: HiveAesCipher(
        Random("$name.hb".hashCode ^ 0x33EF69DF3D6).nextInts(32),
      ),
    ).then((box) => hotBox = box),
    Hive.openLazyBox(
      "$name.cb",
      encryptionCipher: HiveAesCipher(
        Random("$name.cb".hashCode ^ 0x73DE39333F).nextInts(32),
      ),
    ).then((box) => coldBox = box),
  ]);
}

extension _XRand on Random {
  List<int> nextInts(int count) => List.generate(count, (_) => nextInt(256));
}
