import 'dart:async';

import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:flutter/material.dart';

typedef OnMapViewCreated = void Function();
typedef MapEventCallback<T extends MapEvent> = void Function(T event);

abstract class DGisMapPlatform {
  final MapConfig mapConfig;
  final MapWidgetOptions widgetOptions;
  List<MapLayer> layers;

  Stream<CameraPosition> get cameraPositionStream;

  DGisMapPlatform({
    required this.mapConfig,
    required this.widgetOptions,
  }) : layers = mapConfig.layers;

  void on<T extends MapEvent>(MapEventCallback<T> callback);

  static DGisMapPlatform createInstance({
    required MapConfig mapConfig,
    required MapWidgetOptions widgetOptions,
  }) {
    return DGisMapMethodChannel(
      mapConfig: mapConfig,
      widgetOptions: widgetOptions,
    );
  }

  Future<void> addLayer(MapLayer layer);

  Future<void> removeLayerById(String? layerId);

  Future<void> addMarkers(List<Marker> markers, [String? layerId]);

  Future<void> addMarker(Marker marker, [String? layerId]);

  Future<List<Marker>> getAllMarkers([String? layerId]);

  Future<Marker?> getMarkerById(String markerId, [String? layerId]);

  Future<void> removeMarkerById(String markerId, [String? layerId]);

  Future<void> removeAllMarkers([String? layerId]);

  Future<void> update(String markerId, Marker newMarker, [String? layerId]);

  Future<void> moveCamera(
    CameraPosition cameraPosition, {
    Duration duration = Duration.zero,
    CameraAnimationType animationType = CameraAnimationType.DEFAULT,
  });

  Widget buildView({OnMapViewCreated? onCreated});
}
