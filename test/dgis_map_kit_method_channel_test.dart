import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dgis_map_kit/dgis_map_kit_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDgisMapKit platform = MethodChannelDgisMapKit();
  const MethodChannel channel = MethodChannel('dgis_map_kit');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
