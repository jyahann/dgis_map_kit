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
    required double maxZoom,
    //double minZoom = 0,
    required double minDistance,
    ClusterOnTapCallback? onTap,
  }) {
    return ClustererLayer(
      layerId: layerId,
      builder: builder,
      maxZoom: maxZoom,
      minDistance: minDistance,
      //minZoom: minZoom,
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
  //final double minZoom;
  final double maxZoom;
  final double minDistance;

  const ClustererLayer({
    super.layerId,
    required this.builder,
    required this.maxZoom,
    //this.minZoom = 0,
    required this.minDistance,
    this.onTap,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'layerId': layerId,
      "maxZoom": maxZoom,
      //"minZoom": minZoom,
      "minDistance": minDistance,
    };
  }
}
