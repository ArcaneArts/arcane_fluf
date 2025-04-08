library arcane_fluf;

import 'package:arcane/arcane.dart';
import 'package:arcane_fire/arcane_fire.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:serviced/serviced.dart';

Widget ArcaneFluf({
  required Widget child,
  required FirebaseOptions options,
  required VoidCallback onRegisterCrud,
  bool debugFirestoreLogging = false,
  bool debugFirestoreThrowOnGet = false,
  bool splashScreenAutoRemove = true,

  /// Register your user service with () => services().register<YourUserService>(() => YourUserService());
  required VoidCallback onRegisterUserService,
}) => ArcaneFire(
  options: options,
  onRegisterCrud: onRegisterCrud,
  debugFirestoreLogging: debugFirestoreLogging,
  debugFirestoreThrowOnGet: debugFirestoreLogging,
  child: ArcaneFlufCore(
    child: child,
    onRegisterUserService: onRegisterUserService,
    splashScreenAutoRemove: splashScreenAutoRemove,
  ),
);

class ArcaneFlufCore extends StatelessWidget with MagicInitializer {
  final bool splashScreenAutoRemove;
  final VoidCallback onRegisterUserService;

  @override
  final Widget child;

  const ArcaneFlufCore({
    super.key,
    required this.child,
    this.splashScreenAutoRemove = true,
    required this.onRegisterUserService,
  });

  @override
  Widget build(BuildContext context) => child;

  @override
  InitTask get $initializer {
    FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );
    return InitTask("Arcane Fluf", () async {
      onRegisterUserService();
      if (splashScreenAutoRemove) {
        Future.delayed(
          Duration(milliseconds: 50),
          () => FlutterNativeSplash.remove(),
        );
      }
    });
  }
}
