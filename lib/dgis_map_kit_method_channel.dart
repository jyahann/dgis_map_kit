import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dgis_map_kit_platform_interface.dart';

/// An implementation of [DgisMapKitPlatform] that uses method channels.
class MethodChannelDgisMapKit extends DgisMapKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dgis_map_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
