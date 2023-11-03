import 'dart:async';

import 'package:dgis_map_kit/src/controllers/dgis_map_controller.dart';
import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:flutter/material.dart';

typedef MapCreatedCallback = void Function(DGisMapController controller);
typedef MapOnReadyCallback = void Function();
typedef MapOnTapCallback = void Function(Position position);
typedef MarkersOnTapCallback = void Function(Marker marker, String? layerId);
typedef OnUserLocationChangedCallback = void Function(Position position);
typedef CameraOnMoveCallback = void Function(CameraPosition cameraPosition);

// This is a simple Flutter implementation
// of the 2Gis Map SDK, which enables
// cross-platform map development.
class DGisMap extends StatefulWidget {
  // Base map configuration.
  final MapConfig mapConfig;

  // Map on created callback.
  // Executes when platform view created.
  final MapCreatedCallback? mapOnCreated;

  // Map on ready callback.
  // Executes 2Gis map initiated.
  final MapOnReadyCallback? mapOnReady;

  // Map on tap callback.
  // Triggered when clicking on a
  // location on the map where there are no
  // markers or clusters.
  final MapOnTapCallback? mapOnTap;

  // Marker on tap callback.
  /// Executes when user taps on [Marker].
  final MarkersOnTapCallback? markerOnTap;

  // User location on change callback.
  // Executes when user location updates.
  // Enable only when enableMyLocation is true
  final OnUserLocationChangedCallback? onUserLocationChanged;

  // Camera on move callback.
  // Executes when camera position updates.
  final CameraOnMoveCallback? cameraOnMove;

  DGisMap({
    super.key,
    required String token,
    required CameraPosition initialCameraPosition,
    List<MapLayer> layers = const [
      MapLayer(),
    ],
    MapTheme theme = MapTheme.LIGHT,
    this.mapOnTap,
    this.markerOnTap,
    this.mapOnReady,
    this.mapOnCreated,
    this.cameraOnMove,
    this.onUserLocationChanged,
    bool enableMyLocation = false,
  }) : mapConfig = MapConfig(
          token: token,
          initialCameraPosition: initialCameraPosition,
          layers: layers,
          theme: theme,
          enableMyLocation: enableMyLocation,
        );

  @override
  State<DGisMap> createState() => _DGisMapState();
}

class _DGisMapState extends State<DGisMap> {
  final Completer<DGisMapController> _controller =
      Completer<DGisMapController>();

  final Completer<bool> isMapReady = Completer<bool>();

  late DGisMapPlatform _dGisMapPlatform;

  @override
  void initState() {
    _dGisMapPlatform = DGisMapPlatform.createInstance(
      mapConfig: widget.mapConfig,
      widgetOptions: const MapWidgetOptions(
        textDirection: TextDirection.ltr,
      ),
    );
    // TODO: implement initState
    super.initState();
  }

  Future<void> onPlatformViewCreated() async {
    setListeners();
    final controller = DGisMapController(
      dGisMapPlatform: _dGisMapPlatform,
      currentCameraPosition: widget.mapConfig.initialCameraPosition,
    );
    _controller.complete(controller);

    if (widget.mapOnCreated != null) {
      widget.mapOnCreated!(controller);
    }
  }

  // Transfers events to callbacks
  void setListeners() {
    _dGisMapPlatform.on<MapIsReadyEvent>((event) {
      if (!isMapReady.isCompleted) {
        if (widget.mapOnReady != null) widget.mapOnReady!();
        isMapReady.complete(true);
      }
    });
    _dGisMapPlatform.on<MapOnTapEvent>((event) {
      if (widget.mapOnTap != null) widget.mapOnTap!(event.position);
    });
    _dGisMapPlatform.on<MarkersOnTapEvent>((event) {
      if (widget.markerOnTap != null) {
        widget.markerOnTap!(event.marker, event.layerId);
      }
    });
    _dGisMapPlatform.on<ClusterOnTapEvent>((event) {
      for (var layer in _dGisMapPlatform.layers) {
        if (layer is ClustererLayer &&
            layer.layerId == event.layerId &&
            layer.onTap != null) {
          layer.onTap!(event.markers, event.layerId);
        }
      }
    });
    _dGisMapPlatform.on<CameraOnMoveEvent>((event) {
      if (widget.cameraOnMove != null) {
        widget.cameraOnMove!(event.cameraPosition);
      }
    });
    _dGisMapPlatform.on<UserLocationChanged>((event) {
      if (widget.onUserLocationChanged != null) {
        widget.onUserLocationChanged!(event.position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _dGisMapPlatform.buildView(
      onCreated: onPlatformViewCreated,
    );
  }
}
