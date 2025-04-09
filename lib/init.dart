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
  required Function(ServiceProvider) onRegisterServices,
}) => ArcaneFire(
  options: options,
  onRegisterCrud: onRegisterCrud,
  debugFirestoreLogging: debugFirestoreLogging,
  debugFirestoreThrowOnGet: debugFirestoreLogging,
  child: ArcaneFlufCore(
    onRegisterServices: onRegisterServices,
    splashScreenAutoRemove: splashScreenAutoRemove,
    child: child,
  ),
);

class ArcaneFlufCore extends StatelessWidget with MagicInitializer {
  final bool splashScreenAutoRemove;
  final Function(ServiceProvider) onRegisterServices;

  @override
  final Widget child;

  const ArcaneFlufCore({
    super.key,
    required this.child,
    this.splashScreenAutoRemove = true,
    required this.onRegisterServices,
  });

  @override
  Widget build(BuildContext context) => child;

  @override
  InitTask get $initializer {
    FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
    );
    return InitTask("Arcane Fluf", () async {
      onRegisterServices(services());
      if (splashScreenAutoRemove) {
        Future.delayed(
          Duration(milliseconds: 50),
          () => FlutterNativeSplash.remove(),
        );
      }
    });
  }
}
