// Channel method names.
class ChannelMethods {
  // incoming
  static const String mapIsReady = "map#isReady";
  static const String mapOnTap = "map#onTap";
  static const String mapClose = "map#close";
  static const String markersOnTap = "markers#onTap";
  static const String clusterRender = "cluster#render";
  static const String clusterOnTap = "cluster#onTap";
  static const String polylineOnTap = "polyline#onTap";
  static const String cameraOnMove = "camera#onMove";

  // outgoing
  static const String addLayer = "map#addLayer";
  static const String removeLayer = "map#removeLayer";
  static const String setTheme = "map#setTheme";
  static const String addMarkers = "markers#addMarkers";
  static const String addMarker = "markers#addMarker";
  static const String getAllMarkers = "markers#getAll";
  static const String getMarkerById = "markers#getById";
  static const String removeMarkerById = "markers#removeById";
  static const String removeAllMarkers = "markers#removeAll";
  static const String addPolylines = "polylines#addPolylines";
  static const String addPolyline = "polylines#addPolyline";
  static const String getAllPolylines = "polylines#getAll";
  static const String getPolylineById = "polylines#getById";
  static const String removePolylineById = "polylines#removeById";
  static const String removeAllPolylines = "polylines#removeAll";
  static const String moveCamera = "camera#move";
}
