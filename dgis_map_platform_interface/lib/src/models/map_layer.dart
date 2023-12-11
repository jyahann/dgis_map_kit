import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

typedef ClusterBuilder = Cluster Function(List<Marker> markers);
typedef ClusterOnTapCallback = void Function(
  List<Marker> marker,
  Cluster cluster,
  String? layerId,
);

/// The map objects layer with a unique ID.
class MapLayer {
  /// Layer ID should be unique
  /// A layer with a null ID will be the default on the map.
  final String? layerId;

  /// A builder that should return [Cluster]
  /// parameters for rendering it on the map.
  final ClusterBuilder? clusterBuilder;

  /// A map event that triggers
  /// when clicking on a cluster.
  final ClusterOnTapCallback? onTap;

  /// The zoom level from which all markers are visible.
  final double? maxZoom;

  /// The minimum possible screen distance
  /// between marker anchor points at cluster levels
  final double? minDistance;

  /// [MapLayer] with clustering flag.
  final bool withClustering;

  const MapLayer({this.layerId})
      : clusterBuilder = null,
        onTap = null,
        maxZoom = null,
        minDistance = null,
        withClustering = false;

  /// Create markers layer with clustering
  /// Clustering collects groups of [Marker]s
  /// on map into one rendered [Cluster] 
  const MapLayer.withClustering({
    this.layerId,
    required ClusterBuilder this.clusterBuilder,
    required double this.maxZoom,
    required double this.minDistance,
    this.onTap,
  }) : withClustering = true;

  Map<String, dynamic> toJson() {
    return {
      'layerId': layerId,
      "maxZoom": maxZoom,
      "minDistance": minDistance,
      "withClustering": withClustering
    };
  }
}
