import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:dgis_map_platform_interface/src/models/map_creation_params.dart';
import 'package:dgis_map_platform_interface/src/models/map_widget_options.dart';
import 'package:dgis_map_platform_interface/src/models/marker.dart';
import 'package:flutter/material.dart';

typedef OnMapViewCreated = void Function();

abstract class DGisMapPlatform {
  final MapCreationParams creationParams;
  final MapWidgetOptions widgetOptions;

  DGisMapPlatform({
    required this.creationParams,
    required this.widgetOptions,
  });

  static DGisMapPlatform createInstance({
    required MapCreationParams creationParams,
    required MapWidgetOptions widgetOptions,
  }) {
    return DGisMapMethodChannel(
      creationParams: creationParams,
      widgetOptions: widgetOptions,
    );
  }

  Future<void> addMarker(Marker marker);

  Widget buildView({OnMapViewCreated? onCreated});
}
