import 'dart:async';

import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:dgis_map_platform_interface/src/exceptions/layer_exceptions.dart';
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
  Future<void> addLayer(MapLayer layer) async {
    if (layers.any((element) => element.layerId == layer.layerId)) {
      throw LayerAlreadyExistsException(
        message: "Layer with givien id {${layer.layerId}} already exists",
      );
    }

    await _channel.invokeMethod(
      layer is ClustererLayer
          ? ChannelMethods.addLayerWithClustering
          : ChannelMethods.addLayer,
      layer.toJson(),
    );

    layers.add(layer);
  }

  @override
  Future<void> addMarkers(List<Marker> markers, [String? layerId]) async {
    await _channel.invokeMethod(ChannelMethods.addMarkers, {
      "layerId": layerId,
      "markers": markers
          .map<Map<String, dynamic>>((marker) => marker.toJson())
          .toList(),
    });
  }

  @override
  Future<void> addMarker(Marker marker, [String? layerId]) async {
    await _channel.invokeMethod(ChannelMethods.addMarker, {
      "layerId": layerId,
      "marker": marker.toJson(),
    });
  }

  @override
  Future<void> removeLayerById(String? layerId) async {
    _checkLayerExistence(layerId);

    await _channel.invokeMethod(ChannelMethods.removeLayer, {
      "layerId": layerId,
    });
  }

  @override
  Future<List<Marker>> getAllMarkers([String? layerId]) async {
    _checkLayerExistence(layerId);
    final resp = await _channel.invokeMethod(ChannelMethods.getAllMarkers, {
      "layerId": layerId,
    });

    return _getMarkersFromArguments(resp);
  }

  @override
  Future<Marker?> getMarkerById(String markerId, [String? layerId]) async {
    _checkLayerExistence(layerId);
    final resp = await _channel.invokeMethod(ChannelMethods.getMarkerById, {
      "layerId": layerId,
      "markerId": markerId,
    });

    return resp != null ? Marker.fromJson(_getArgumentDictionary(resp)) : null;
  }

  @override
  Future<void> removeAllMarkers([String? layerId]) async {
    _checkLayerExistence(layerId);
    await _channel.invokeMethod(ChannelMethods.removeAllMarkers, {
      "layerId": layerId,
    });
  }

  @override
  Future<void> removeMarkerById(String markerId, [String? layerId]) async {
    _checkLayerExistence(layerId);
    await _channel.invokeMethod(ChannelMethods.removeMarkerById, {
      "layerId": layerId,
      "markerId": markerId,
    });
  }

  @override
  Future<void> update(
    String markerId,
    Marker newMarker, [
    String? layerId,
  ]) async {
    _checkLayerExistence(layerId);
    await _channel.invokeMethod(ChannelMethods.removeMarkerById, {
      "layerId": layerId,
      "markerId": markerId,
      "newMarker": newMarker.toJson(),
    });
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

  void _checkLayerExistence(String? layerId) {
    if (!layers.any((element) => element.layerId == layerId)) {
      throw LayerNotExistsException(
        message: "Layer with givien id {${layerId}} not exists",
      );
    }
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
              layerId: call.arguments["layerId"],
              marker: Marker.fromJson(
                _getArgumentDictionary(
                  arguments["data"],
                ),
              ),
            ),
          );
          break;
        case ChannelMethods.clusterRender:
          final args = _getArgumentDictionary(call.arguments);
          final layer = layers.firstWhere(
            (layer) => layer.layerId == args["layerId"],
          );

          return (layer as ClustererLayer)
              .builder(_getMarkersFromArguments(args["data"]))
              .toJson();
        case ChannelMethods.clusterOnTap:
          _mapEventStreamController.add(
            ClusterOnTapEvent(
              layerId: call.arguments["layerId"],
              markers: _getMarkersFromArguments(call.arguments["markers"]),
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
