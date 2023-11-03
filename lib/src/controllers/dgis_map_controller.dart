import 'dart:async';

import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:dgis_map_kit/src/controllers/markers_controller.dart';
import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

class DGisMapController {
  // Markers controller, used to perform operations on them.
  final MarkersController markersController;

  final DGisMapPlatform _dGisMapPlatform;

  /// Map [CameraPosition] stream getter.
  Stream<CameraPosition> get cameraPositionStream {
    return _dGisMapPlatform.cameraPositionStream;
  }

  /// Map [CameraPosition] getter.
  CameraPosition currentCameraPosition;

  // Map existing layers getter.
  List<MapLayer> get layers {
    return _dGisMapPlatform.layers;
  }

  DGisMapController({
    required DGisMapPlatform dGisMapPlatform,
    required this.currentCameraPosition,
  })  : _dGisMapPlatform = dGisMapPlatform,
        markersController =
            MarkersController(dGisMapPlatform: dGisMapPlatform) {
    cameraPositionStream.listen(
      (position) => currentCameraPosition = position,
    );
  }

  /// Add [MapLayer] o map.
  /// [MapLayer] layerId must be unique.
  /// A [MapLayer] with a null [MapLayer.layerId]
  /// will be considered the default.
  /// You cannot create a [MapLayer] with a null
  /// [MapLayer.layerId] if one already exists.
  Future<void> addLayer(MapLayer layer) async {
    await _dGisMapPlatform.addLayer(layer);
  }

  /// Remove [MapLayer] with given [layerId].
  /// An error will occur if the layer with
  /// the specified layerId does not exist.
  /// This command will delete all objects on this [MapLayer].
  Future<void> removeLayerById(String? layerId) async {
    await _dGisMapPlatform.removeLayerById(layerId);
  }

  /// Moves the map camera to the specified
  /// [CameraPosition] with a defined [duration] and [animationType].
  Future<void> moveCamera(
    CameraPosition cameraPosition, {
    Duration duration = Duration.zero,
    CameraAnimationType animationType = CameraAnimationType.DEFAULT,
  }) async {
    await _dGisMapPlatform.moveCamera(
      cameraPosition,
      duration: duration,
      animationType: animationType,
    );
  }
}
