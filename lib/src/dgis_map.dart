import 'dart:async';

import 'package:dgis_map_kit/src/controller/dgis_map_controller.dart';
import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:flutter/material.dart';

typedef MapCreatedCallback = void Function(DGisMapController controller);
typedef MapOnTapCallback = void Function(Position position);
typedef MarkersOnTapCallback = void Function(Marker marker);
typedef ClustersOnTapCallback = void Function(List<Marker> markers);
typedef CameraOnMove = void Function(CameraPosition cameraPosition);
typedef ClustererBuilder = MapClusterer Function(List<Marker> markers);

// ignore: must_be_immutable
class DGisMap extends StatefulWidget {
  final MapConfig mapConfig;

  final MapCreatedCallback? onMapCreated;

  final MapOnTapCallback? mapOnTap;

  final MarkersOnTapCallback? markerOnTap;

  final ClustersOnTapCallback? clusterOnTap;

  final CameraOnMove? cameraOnMove;

  DGisMap({
    super.key,
    required String token,
    required CameraPosition initialCameraPosition,
    this.mapOnTap,
    this.markerOnTap,
    this.onMapCreated,
    this.cameraOnMove,
  })  : mapConfig = MapConfig(
          token: token,
          initialCameraPosition: initialCameraPosition,
        ),
        clusterOnTap = null;

  DGisMap.withClustering({
    super.key,
    required String token,
    required CameraPosition initialCameraPosition,
    this.mapOnTap,
    this.markerOnTap,
    this.onMapCreated,
    this.cameraOnMove,
    required ClustererBuilder clustererBuilder,
    this.clusterOnTap,
  }) : mapConfig = MapConfig(
          token: token,
          initialCameraPosition: initialCameraPosition,
          clustererBuilder: clustererBuilder,
        );

  @override
  State<DGisMap> createState() => _DGisMapState();
}

class _DGisMapState extends State<DGisMap> {
  final Completer<DGisMapController> _controller =
      Completer<DGisMapController>();

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
    );
    _controller.complete(controller);

    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }
  }

  void setListeners() {
    _dGisMapPlatform.on<MapOnTapEvent>((event) {
      if (widget.mapOnTap != null) widget.mapOnTap!(event.position);
    });
    _dGisMapPlatform.on<MarkersOnTapEvent>((event) {
      if (widget.markerOnTap != null) widget.markerOnTap!(event.marker);
    });
    _dGisMapPlatform.on<ClusterOnTapEvent>((event) {
      if (widget.clusterOnTap != null) widget.clusterOnTap!(event.markers);
    });
    _dGisMapPlatform.on<CameraOnMoveEvent>((event) {
      if (widget.cameraOnMove != null)
        widget.cameraOnMove!(event.cameraPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _dGisMapPlatform.buildView(
      onCreated: onPlatformViewCreated,
    );
  }
}
