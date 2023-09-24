import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dgis_map_kit_method_channel.dart';

abstract class DgisMapKitPlatform extends PlatformInterface {
  /// Constructs a DgisMapKitPlatform.
  DgisMapKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static DgisMapKitPlatform _instance = MethodChannelDgisMapKit();

  /// The default instance of [DgisMapKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelDgisMapKit].
  static DgisMapKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DgisMapKitPlatform] when
  /// they register themselves.
  static set instance(DgisMapKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
