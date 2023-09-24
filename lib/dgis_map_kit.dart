
import 'dgis_map_kit_platform_interface.dart';

class DgisMapKit {
  Future<String?> getPlatformVersion() {
    return DgisMapKitPlatform.instance.getPlatformVersion();
  }
}
