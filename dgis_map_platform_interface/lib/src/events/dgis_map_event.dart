import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:dgis_map_platform_interface/src/models/polyline.dart';

// Map events.
sealed class MapEvent {
  const MapEvent();
}

class MapIsReadyEvent extends MapEvent {
  const MapIsReadyEvent();
}

class MapOnTapEvent extends MapEvent {
  final Position position;

  const MapOnTapEvent({required this.position});
}

class MarkersOnTapEvent extends MapEvent {
  final String? layerId;
  final Marker marker;

  const MarkersOnTapEvent({
    this.layerId,
    required this.marker,
  });
}

class ClusterOnTapEvent extends MapEvent {
  final String? layerId;
  final Cluster cluster;
  final List<Marker> markers;

  const ClusterOnTapEvent({
    this.layerId,
    required this.cluster,
    required this.markers,
  });
}

class PolylineOnTapEvent extends MapEvent {
  final String? layerId;
  final Polyline polyline;

  const PolylineOnTapEvent({
    this.layerId,
    required this.polyline,
  });
}

class CameraOnMoveEvent extends MapEvent {
  final CameraPosition cameraPosition;

  const CameraOnMoveEvent({required this.cameraPosition});
}

class UserLocationChanged extends MapEvent {
  final Position position;

  const UserLocationChanged({required this.position});
}
