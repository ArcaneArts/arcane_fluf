import 'package:dart_mappable/dart_mappable.dart';

part 'fluf_device.mapper.dart';

@MappableClass()
class FlufDevice with FlufDeviceMappable {
  final String platform;
  final String fcmToken;
  final DateTime lastSeen;
  final DateTime createdAt;

  FlufDevice({
    required this.platform,
    required this.fcmToken,
    required this.lastSeen,
    required this.createdAt,
  });
}
