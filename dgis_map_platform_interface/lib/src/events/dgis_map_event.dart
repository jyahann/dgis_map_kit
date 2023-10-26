import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

abstract class MapEvent {
  const MapEvent();
}

class MarkersOnTapEvent extends MapEvent {
  final Marker marker;

  const MarkersOnTapEvent({required this.marker});
}

class ClusterOnTapEvent extends MapEvent {
  final List<Marker> markers;

  const ClusterOnTapEvent({required this.markers});
}
