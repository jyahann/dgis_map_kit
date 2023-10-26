import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/dgis_map_event.dart';
import 'package:dgis_map_platform_interface/src/models/marker.dart';
import 'package:dgis_map_platform_interface/src/platform_interface/dgis_map_platform.dart';
import 'package:dgis_map_platform_interface/src/utils/incoming_methods.dart';
import 'package:dgis_map_platform_interface/src/utils/outgoing_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:stream_transform/stream_transform.dart';
import 'dart:developer' as log;

class DGisMapMethodChannel extends DGisMapPlatform {
  static const String _viewType = "plugins.jyahann/dgis_map";

  late MethodChannel _channel;

  final bool useHybridComposition;

  DGisMapMethodChannel({
    required super.mapConfig,
    required super.widgetOptions,
    this.useHybridComposition = false,
  });

  final StreamController<MapEvent> _mapEventStreamController =
      StreamController<MapEvent>.broadcast();

  @override
  void on<T extends MapEvent>(MapEventCallback<T> callback) {
    _mapEventStreamController.stream.whereType<T>().listen(callback);
  }

  void _initChannel(int id) {
    _channel = MethodChannel("${_viewType}_${id.toString()}");
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  Future<void> addMarkers(List<Marker> markers) async {
    await _channel.invokeMethod(
      OutgoingMethods.addMarkers,
      OutgoingMethods.addMarkersMap(markers),
    );
  }

  // @override
  // Stream<MarkersOnTapEvent> onMarkerTap({required int mapId}) {
  //   return _events.whereType<MarkersOnTapEvent>();
  // }

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

  Map<String, Object?> _getArgumentDictionary(dynamic arguments) {
    return (arguments as Map<Object?, Object?>).cast<String, Object?>();
  }

  List<Marker> _getMarkersFromArguments(dynamic arguments) {
    List<Marker> markers = [];
    for (var markerJson in arguments) {
      final markerJsonDict = _getArgumentDictionary(markerJson);
      markers.add(Marker.fromJson(markerJsonDict));
    }
    return markers;
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      switch (call.method) {
        case IncomingMethods.markersOnTap:
          final arguments = _getArgumentDictionary(call.arguments);
          _mapEventStreamController.add(
            MarkersOnTapEvent(
              marker: Marker.fromJson(arguments),
            ),
          );
          break;
        case IncomingMethods.clusterRender:
          return mapConfig.clustererBuilder!
                  (_getMarkersFromArguments(call.arguments))
              .toJson();
        case IncomingMethods.clusterOnTap:
          _mapEventStreamController.add(
            ClusterOnTapEvent(
              markers: _getMarkersFromArguments(call.arguments),
            ),
          );
          break;
        default:
          throw MissingPluginException();
      }
    } catch (e) {
      log.log("Error on holding DGis method call", name: e.toString());
    }
  }
}
