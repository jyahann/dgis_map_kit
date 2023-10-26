import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

class OutgoingMethods {
  static const String addMarkers = "map#addMarkers";

  static dynamic addMarkersMap(List<Marker> markers) {
    return markers
        .map<Map<String, dynamic>>((marker) => marker.toJson())
        .toList();
  }
}
