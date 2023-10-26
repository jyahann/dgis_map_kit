import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

class MapConfig {
  final String token;
  final MapClusterer Function(List<Marker> markers)? clustererBuilder;

  const MapConfig({
    required this.token,
    this.clustererBuilder,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'isClusteringEnabled': clustererBuilder != null,
    };
  }
}
