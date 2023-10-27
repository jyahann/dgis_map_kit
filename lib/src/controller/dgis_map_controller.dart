import 'dart:async';

import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:flutter/foundation.dart';

class DGisMapController extends ChangeNotifier {
  final StreamController<CameraPosition> _cameraPositionStreamController =
      StreamController<CameraPosition>.broadcast();

  Stream<CameraPosition> get cameraPositionStream {
    return _cameraPositionStreamController.stream;
  }

  Future<CameraPosition> get currentCameraPosition {
    return cameraPositionStream.last;
  }

  final DGisMapPlatform _dGisMapPlatform;

  DGisMapController({
    required DGisMapPlatform dGisMapPlatform,
  }) : _dGisMapPlatform = dGisMapPlatform;

  Future<void> addMarkers(List<Marker> markers) async {
    await _dGisMapPlatform.addMarkers(markers);
  }

  Future<void> addMarker(Marker marker) async {
    await _dGisMapPlatform.addMarker(marker);
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

  void setListeners() {
    _dGisMapPlatform.on<CameraOnMoveEvent>(
      (event) => _cameraPositionStreamController.add(event.cameraPosition),
    );
  }
}
