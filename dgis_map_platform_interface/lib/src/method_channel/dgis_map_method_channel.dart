import 'dart:async';

import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:dgis_map_platform_interface/src/utils/channel_methods.dart';
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
      ChannelMethods.addMarkers,
      markers.map<Map<String, dynamic>>((marker) => marker.toJson()).toList(),
    );
  }

  @override
  Future<void> addMarker(Marker marker) async {
    await _channel.invokeMethod(
      ChannelMethods.addMarkers,
      marker.toJson(),
    );
  }

  @override
  Future<void> moveCamera(
    CameraPosition cameraPosition, {
    Duration duration = Duration.zero,
    CameraAnimationType animationType = CameraAnimationType.DEFAULT,
  }) async {
    await _channel.invokeMethod(
      ChannelMethods.moveCamera,
      {
        "cameraPosition": cameraPosition.toJson(),
        "durationInMilliseconds": duration.inMilliseconds,
        "animationType": animationType.name,
      },
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
        case ChannelMethods.mapOnTap:
          final arguments = _getArgumentDictionary(call.arguments);
          _mapEventStreamController.add(
            MapOnTapEvent(
              position: Position.fromJson(arguments),
            ),
          );
          break;
        case ChannelMethods.markersOnTap:
          final arguments = _getArgumentDictionary(call.arguments);
          _mapEventStreamController.add(
            MarkersOnTapEvent(
              marker: Marker.fromJson(arguments),
            ),
          );
          break;
        case ChannelMethods.clusterRender:
          return mapConfig.clustererBuilder!
                  (_getMarkersFromArguments(call.arguments))
              .toJson();
        case ChannelMethods.clusterOnTap:
          _mapEventStreamController.add(
            ClusterOnTapEvent(
              markers: _getMarkersFromArguments(call.arguments),
            ),
          );
          break;
        case ChannelMethods.cameraOnMove:
          final arguments = _getArgumentDictionary(call.arguments);
          _mapEventStreamController.add(
            CameraOnMoveEvent(
              cameraPosition: CameraPosition.fromJson(arguments),
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
