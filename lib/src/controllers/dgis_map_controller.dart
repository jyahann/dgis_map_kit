import 'dart:async';

import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:dgis_map_kit/src/controllers/markers_controller.dart';
import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

class DGisMapController {
  final MarkersController markersController;

  final DGisMapPlatform _dGisMapPlatform;

  Stream<CameraPosition> get cameraPositionStream {
    return _dGisMapPlatform.cameraPositionStream;
  }

  CameraPosition currentCameraPosition;

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

  Future<void> addLayer(MapLayer layer) async {
    await _dGisMapPlatform.addLayer(layer);
  }

  Future<void> removeLayerById(String? layerId) async {
    await _dGisMapPlatform.removeLayerById(layerId);
  }

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
