import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

abstract class MapEvent {
  const MapEvent();
}

class MapOnTapEvent extends MapEvent {
  final Position position;

  const MapOnTapEvent({required this.position});
}

class MarkersOnTapEvent extends MapEvent {
  final Marker marker;

  const MarkersOnTapEvent({required this.marker});
}

class ClusterOnTapEvent extends MapEvent {
  final List<Marker> markers;

  const ClusterOnTapEvent({required this.markers});
}

class CameraOnMoveEvent extends MapEvent {
  final CameraPosition cameraPosition;

  const CameraOnMoveEvent({required this.cameraPosition});
}
