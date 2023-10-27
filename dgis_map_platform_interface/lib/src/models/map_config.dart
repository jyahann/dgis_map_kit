import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

class MapConfig {
  final String token;
  final CameraPosition initialCameraPosition;
  final MapClusterer Function(List<Marker> markers)? clustererBuilder;

  const MapConfig({
    required this.token,
    required this.initialCameraPosition,
    this.clustererBuilder,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'initialCameraPosition': initialCameraPosition.toJson(),
      'isClusteringEnabled': clustererBuilder != null,
    };
  }
}
