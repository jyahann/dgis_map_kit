import 'dart:async';

import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

class MarkersController {
  final DGisMapPlatform _dGisMapPlatform;

  MarkersController({
    required DGisMapPlatform dGisMapPlatform,
  }) : _dGisMapPlatform = dGisMapPlatform;

  Future<void> addMarkers(List<Marker> markers, [String? layerId]) =>
      _dGisMapPlatform.addMarkers(markers, layerId);

  Future<void> addMarker(Marker marker, [String? layerId]) =>
      _dGisMapPlatform.addMarker(marker, layerId);

  Future<List<Marker>> getAll([String? layerId]) =>
      _dGisMapPlatform.getAllMarkers(layerId);

  Future<Marker?> getById(String markerId, [String? layerId]) =>
      _dGisMapPlatform.getMarkerById(markerId, layerId);

  Future<void> removeById(String markerId, [String? layerId]) =>
      _dGisMapPlatform.removeMarkerById(markerId, layerId);

  Future<void> removeAll([String? layerId]) =>
      _dGisMapPlatform.removeAllMarkers(layerId);

  Future<void> update(String markerId, Marker newMarker, [String? layerId]) =>
      _dGisMapPlatform.update(markerId, newMarker, layerId);
}
