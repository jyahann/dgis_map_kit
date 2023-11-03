import 'dart:async';

import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

class MarkersController {
  final DGisMapPlatform _dGisMapPlatform;

  MarkersController({
    required DGisMapPlatform dGisMapPlatform,
  }) : _dGisMapPlatform = dGisMapPlatform;

  // Add list of markers to the map
  /// [Marker] id should be unique or null.
  // If marker with given id already exists, it will be overwritten.
  Future<void> addMarkers(List<Marker> markers, [String? layerId]) =>
      _dGisMapPlatform.addMarkers(markers, layerId);

  /// Add [Marker] to the map
  /// [Marker] id should be unique or null.
  /// If [Marker] with given id already exists,
  /// it will be overwritten.
  Future<void> addMarker(Marker marker, [String? layerId]) =>
      _dGisMapPlatform.addMarker(marker, layerId);

  // Get all markers.
  Future<List<Marker>> getAll([String? layerId]) =>
      _dGisMapPlatform.getAllMarkers(layerId);

  /// Get [Marker] by given [markerId].
  /// It will return null if a [Marker] with
  /// the specified ID does not exist.
  Future<Marker?> getById(String markerId, [String? layerId]) =>
      _dGisMapPlatform.getMarkerById(markerId, layerId);

  /// Remove [Marker] by given [markerId].
  Future<void> removeById(String markerId, [String? layerId]) =>
      _dGisMapPlatform.removeMarkerById(markerId, layerId);

  /// Remove all markers on layer.
  Future<void> removeAll([String? layerId]) =>
      _dGisMapPlatform.removeAllMarkers(layerId);

  /// It will overwrite the [Marker]
  /// with the specified [markerId] with a new one.
  Future<void> update(String markerId, Marker newMarker, [String? layerId]) =>
      _dGisMapPlatform.update(markerId, newMarker, layerId);
}
