import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/dgis_map_event.dart';
import 'package:dgis_map_platform_interface/src/models/map_config.dart';
import 'package:dgis_map_platform_interface/src/models/marker.dart';
import 'package:dgis_map_platform_interface/src/platform_interface/dgis_map_platform.dart';
import 'package:dgis_map_platform_interface/src/utils/outgoing_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class DGisMapMethodChannel extends DGisMapPlatform {
  static const String _viewType = "plugins.jyahann/dgis_map";

  late MethodChannel _channel;

  // final StreamController<MapEvent> _mapEventStreamController =
  //     StreamController<MapEvent>.broadcast();

  final bool useHybridComposition;

  DGisMapMethodChannel({
    required super.mapConfig,
    required super.widgetOptions,
    this.useHybridComposition = false,
  });

  void _initChannel(int id) {
    _channel = MethodChannel("${_viewType}_${id.toString()}");
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  Future<void> addMarkers(List<Marker> markers) async {
    await _channel.invokeMethod(
      OutgoingMethods.addMarkers,
      markers.map<Map<String, dynamic>>((marker) => marker.toJson()).toList(),
    );
  }

  @override
  Widget buildView({
    OnMapViewCreated? onCreated,
  }) {
    final Map<String, dynamic> creationParams = mapConfig.toJson();
    onPlatforViewCreated(int id) {
      _initChannel(id);
      if (onCreated != null) {
        onCreated();
      }
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      if (useHybridComposition) {
        return PlatformViewLink(
          viewType: _viewType,
          surfaceFactory: (
            BuildContext context,
            PlatformViewController controller,
          ) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: widgetOptions.gestureRecognizers,
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            final SurfaceAndroidViewController controller =
                PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: _viewType,
              layoutDirection: widgetOptions.textDirection,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () => params.onFocusChanged(true),
            );
            controller.addOnPlatformViewCreatedListener(
              params.onPlatformViewCreated,
            );
            controller.addOnPlatformViewCreatedListener(
              onPlatforViewCreated,
            );

            controller.create();
            return controller;
          },
        );
      } else {
        return AndroidView(
          viewType: _viewType,
          onPlatformViewCreated: onPlatforViewCreated,
          gestureRecognizers: widgetOptions.gestureRecognizers,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: _viewType,
        onPlatformViewCreated: onPlatforViewCreated,
        gestureRecognizers: widgetOptions.gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return Text(
      '$defaultTargetPlatform is not yet supported by the maps plugin',
    );
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call) {
      default:
        throw MissingPluginException();
    }
  }
}
