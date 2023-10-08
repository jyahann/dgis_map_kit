import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:flutter/foundation.dart';

class DGisMapController extends ChangeNotifier {
  final DGisMapPlatform _dGisMapPlatform;

  DGisMapController({
    required DGisMapPlatform dGisMapPlatform,
  }) : _dGisMapPlatform = dGisMapPlatform;

  Future<void> addMarkers(List<Marker> markers) async {
    await _dGisMapPlatform.addMarkers(markers);
  }
}
