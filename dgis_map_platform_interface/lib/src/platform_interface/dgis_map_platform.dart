import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:flutter/material.dart';

typedef OnMapViewCreated = void Function();

abstract class DGisMapPlatform {
  final MapConfig mapConfig;
  final MapWidgetOptions widgetOptions;

  DGisMapPlatform({
    required this.mapConfig,
    required this.widgetOptions,
  });

  static DGisMapPlatform createInstance({
    required MapConfig mapConfig,
    required MapWidgetOptions widgetOptions,
  }) {
    return DGisMapMethodChannel(
      mapConfig: mapConfig,
      widgetOptions: widgetOptions,
    );
  }

  Future<void> addMarkers(List<Marker> markers);

  Widget buildView({OnMapViewCreated? onCreated});
}
