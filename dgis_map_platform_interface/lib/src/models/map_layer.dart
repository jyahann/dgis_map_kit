import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

typedef ClustererLayerBuilder = MapClusterer Function(List<Marker> markers);
typedef ClusterOnTapCallback = void Function(
    List<Marker> marker, String? layerId);

class MapLayer {
  final String? layerId;

  const MapLayer({this.layerId});

  static ClustererLayer withClustering({
    String? layerId,
    required MapClusterer Function(List<Marker> markers) builder,
    ClusterOnTapCallback? onTap,
  }) {
    return ClustererLayer(
      layerId: layerId,
      builder: builder,
      onTap: onTap,
    );
  }

  Map<String, dynamic> toJson() {
    return {'layerId': layerId};
  }
}

class ClustererLayer extends MapLayer {
  final ClustererLayerBuilder builder;
  final ClusterOnTapCallback? onTap;

  const ClustererLayer({
    super.layerId,
    required this.builder,
    this.onTap,
  });
}
