import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

typedef ClustererLayerBuilder = MapClusterer Function(List<Marker> markers);
typedef ClusterOnTapCallback = void Function(
  List<Marker> marker,
  String? layerId,
);

// The default map marker layer with a unique ID.
class MapLayer {
  // Layer ID should be unique
  // A layer with a null ID will be the default on the map.
  final String? layerId;

  const MapLayer({this.layerId});

  // Create a layer with marker clustering on the map.
  static ClustererLayer withClustering({
    // Layer ID should be unique
    // A layer with a null ID will be the default on the map.
    String? layerId,

    // A builder that should return cluster
    // parameters for rendering it on the map.
    required MapClusterer Function(List<Marker> markers) builder,

    // The zoom level from which all markers are visible.
    required double maxZoom,

    // The minimum possible screen distance
    // between marker anchor points at cluster levels
    required double minDistance,

    // A map event that triggers
    // when clicking on a cluster.
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

// A layer with marker clustering on the map.
class ClustererLayer extends MapLayer {
  // A builder that should return cluster
  // parameters for rendering it on the map.
  final ClustererLayerBuilder builder;

  // A map event that triggers
  // when clicking on a cluster.
  final ClusterOnTapCallback? onTap;

  // The zoom level from which all markers are visible.
  final double maxZoom;

  // The minimum possible screen distance
  // between marker anchor points at cluster levels
  final double minDistance;

  const ClustererLayer({
    super.layerId,
    required this.builder,
    required this.maxZoom,
    required this.minDistance,
    this.onTap,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'layerId': layerId,
      "maxZoom": maxZoom,
      "minDistance": minDistance,
    };
  }
}
