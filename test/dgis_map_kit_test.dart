import 'package:flutter_test/flutter_test.dart';
import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:dgis_map_kit/dgis_map_kit_platform_interface.dart';
import 'package:dgis_map_kit/dgis_map_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDgisMapKitPlatform
    with MockPlatformInterfaceMixin
    implements DgisMapKitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DgisMapKitPlatform initialPlatform = DgisMapKitPlatform.instance;

  test('$MethodChannelDgisMapKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDgisMapKit>());
  });

  test('getPlatformVersion', () async {
    DgisMapKit dgisMapKitPlugin = DgisMapKit();
    MockDgisMapKitPlatform fakePlatform = MockDgisMapKitPlatform();
    DgisMapKitPlatform.instance = fakePlatform;

    expect(await dgisMapKitPlugin.getPlatformVersion(), '42');
  });
}
