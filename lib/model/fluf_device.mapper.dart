// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fluf_device.dart';

class FlufDeviceMapper extends ClassMapperBase<FlufDevice> {
  FlufDeviceMapper._();

  static FlufDeviceMapper? _instance;
  static FlufDeviceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FlufDeviceMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FlufDevice';

  static String _$platform(FlufDevice v) => v.platform;
  static const Field<FlufDevice, String> _f$platform =
      Field('platform', _$platform);
  static String _$fcmToken(FlufDevice v) => v.fcmToken;
  static const Field<FlufDevice, String> _f$fcmToken =
      Field('fcmToken', _$fcmToken);
  static DateTime _$lastSeen(FlufDevice v) => v.lastSeen;
  static const Field<FlufDevice, DateTime> _f$lastSeen =
      Field('lastSeen', _$lastSeen);
  static DateTime _$createdAt(FlufDevice v) => v.createdAt;
  static const Field<FlufDevice, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);

  @override
  final MappableFields<FlufDevice> fields = const {
    #platform: _f$platform,
    #fcmToken: _f$fcmToken,
    #lastSeen: _f$lastSeen,
    #createdAt: _f$createdAt,
  };

  static FlufDevice _instantiate(DecodingData data) {
    return FlufDevice(
        platform: data.dec(_f$platform),
        fcmToken: data.dec(_f$fcmToken),
        lastSeen: data.dec(_f$lastSeen),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static FlufDevice fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FlufDevice>(map);
  }

  static FlufDevice fromJson(String json) {
    return ensureInitialized().decodeJson<FlufDevice>(json);
  }
}

mixin FlufDeviceMappable {
  String toJson() {
    return FlufDeviceMapper.ensureInitialized()
        .encodeJson<FlufDevice>(this as FlufDevice);
  }

  Map<String, dynamic> toMap() {
    return FlufDeviceMapper.ensureInitialized()
        .encodeMap<FlufDevice>(this as FlufDevice);
  }

  FlufDeviceCopyWith<FlufDevice, FlufDevice, FlufDevice> get copyWith =>
      _FlufDeviceCopyWithImpl<FlufDevice, FlufDevice>(
          this as FlufDevice, $identity, $identity);
  @override
  String toString() {
    return FlufDeviceMapper.ensureInitialized()
        .stringifyValue(this as FlufDevice);
  }

  @override
  bool operator ==(Object other) {
    return FlufDeviceMapper.ensureInitialized()
        .equalsValue(this as FlufDevice, other);
  }

  @override
  int get hashCode {
    return FlufDeviceMapper.ensureInitialized().hashValue(this as FlufDevice);
  }
}

extension FlufDeviceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FlufDevice, $Out> {
  FlufDeviceCopyWith<$R, FlufDevice, $Out> get $asFlufDevice =>
      $base.as((v, t, t2) => _FlufDeviceCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FlufDeviceCopyWith<$R, $In extends FlufDevice, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? platform,
      String? fcmToken,
      DateTime? lastSeen,
      DateTime? createdAt});
  FlufDeviceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FlufDeviceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FlufDevice, $Out>
    implements FlufDeviceCopyWith<$R, FlufDevice, $Out> {
  _FlufDeviceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FlufDevice> $mapper =
      FlufDeviceMapper.ensureInitialized();
  @override
  $R call(
          {String? platform,
          String? fcmToken,
          DateTime? lastSeen,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (platform != null) #platform: platform,
        if (fcmToken != null) #fcmToken: fcmToken,
        if (lastSeen != null) #lastSeen: lastSeen,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  FlufDevice $make(CopyWithData data) => FlufDevice(
      platform: data.get(#platform, or: $value.platform),
      fcmToken: data.get(#fcmToken, or: $value.fcmToken),
      lastSeen: data.get(#lastSeen, or: $value.lastSeen),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  FlufDeviceCopyWith<$R2, FlufDevice, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FlufDeviceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
