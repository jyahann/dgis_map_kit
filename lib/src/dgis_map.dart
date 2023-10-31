import 'dart:async';

import 'package:dgis_map_kit/src/controllers/dgis_map_controller.dart';
import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:flutter/material.dart';

typedef MapCreatedCallback = void Function(DGisMapController controller);
typedef MapOnReadyCallback = void Function();
typedef MapOnTapCallback = void Function(Position position);
typedef MarkersOnTapCallback = void Function(Marker marker, String? layerId);
typedef CameraOnMove = void Function(CameraPosition cameraPosition);

// ignore: must_be_immutable
class DGisMap extends StatefulWidget {
  final MapConfig mapConfig;

  final MapCreatedCallback? mapOnCreated;

  final MapOnReadyCallback? mapOnReady;

  final MapOnTapCallback? mapOnTap;

  final MarkersOnTapCallback? markerOnTap;

  final CameraOnMove? cameraOnMove;

  DGisMap({
    super.key,
    required String token,
    required CameraPosition initialCameraPosition,
    List<MapLayer> layers = const [
      MapLayer(),
    ],
    MapTheme theme = MapTheme.light,
    this.mapOnTap,
    this.markerOnTap,
    this.mapOnReady,
    this.mapOnCreated,
    this.cameraOnMove,
  }) : mapConfig = MapConfig(
          token: token,
          initialCameraPosition: initialCameraPosition,
          layers: layers,
          theme: theme,
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
  }

  @override
  Widget build(BuildContext context) {
    return _dGisMapPlatform.buildView(
      onCreated: onPlatformViewCreated,
    );
  }
}
