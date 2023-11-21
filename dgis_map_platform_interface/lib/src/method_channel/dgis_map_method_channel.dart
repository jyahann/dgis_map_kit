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

// 2Gis Map platform-specific method channel.
class DGisMapMethodChannel extends DGisMapPlatform {
  // 2Gis Map method channel name.
  static const String _viewType = "plugins.jyahann/dgis_map";

  // Map view method channel.
  late MethodChannel _channel;

  /// Saved list of [MapLayer] to audit for.
  List<MapLayer> _layers;

  // Map existing layers getter.
  @override
  List<MapLayer> get layers {
    return _layers;
  }

  // User hybrid compoisition flag
  final bool useHybridComposition;

  /// Map [CameraPosition] stream controller.
  final StreamController<CameraPosition> _cameraPositionStreamController =
      StreamController<CameraPosition>.broadcast();

  /// Map [CameraPosition] stream getter.
  @override
  Stream<CameraPosition> get cameraPositionStream {
    return _cameraPositionStreamController.stream;
  }

  DGisMapMethodChannel({
    required super.mapConfig,
    required super.widgetOptions,
    this.useHybridComposition = false,
  }) : _layers = mapConfig.layers.toList();

  final StreamController<MapEvent> _mapEventStreamController =
      StreamController<MapEvent>.broadcast();

  /// Basic [MapEvent] bus
  @override
  StreamSubscription<T> on<T extends MapEvent>(MapEventCallback<T> callback) {
    return _mapEventStreamController.stream.whereType<T>().listen(callback);
  }

  /// Initiate [_channel]
  void _initChannel(int id) {
    _channel = MethodChannel("${_viewType}_${id.toString()}");
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  /// Add [MapLayer] o map.
  /// [MapLayer] layerId must be unique.
  /// A [MapLayer] with a null [MapLayer.layerId]
  /// will be considered the default.
  /// You cannot create a [MapLayer] with a null
  /// [MapLayer.layerId] if one already exists.
  @override
  Future<void> addLayer(MapLayer layer) async {
    // Check layer existence.
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

    _layers.add(layer);
  }

  /// Remove [MapLayer] with given [layerId].
  /// An error will occur if the layer with
  /// the specified layerId does not exist.
  /// This command will delete all objects on this [MapLayer].
  @override
  Future<void> removeLayerById(String? layerId) async {
    _checkLayerExistence(layerId);

    await _channel.invokeMethod(ChannelMethods.removeLayer, {
      "layerId": layerId,
    });
  }

  // Add list of markers to the map
  /// [Marker] id should be unique or null.
  // If marker with given id already exists, it will be overwritten.
  @override
  Future<void> addMarkers(List<Marker> markers, [String? layerId]) async {
    await _channel.invokeMethod(ChannelMethods.addMarkers, {
      "layerId": layerId,
      "markers": markers
          .map<Map<String, dynamic>>((marker) => marker.toJson())
          .toList(),
    });
  }

  /// Add [Marker] to the map
  /// [Marker] id should be unique or null.
  /// If [Marker] with given id already exists,
  /// it will be overwritten.
  @override
  Future<void> addMarker(Marker marker, [String? layerId]) async {
    await _channel.invokeMethod(ChannelMethods.addMarker, {
      "layerId": layerId,
      "marker": marker.toJson(),
    });
  }

  // Get all markers.
  @override
  Future<List<Marker>> getAllMarkers([String? layerId]) async {
    _checkLayerExistence(layerId);
    final resp = await _channel.invokeMethod(ChannelMethods.getAllMarkers, {
      "layerId": layerId,
    });

    return _getMarkersFromArguments(resp);
  }

  /// Get [Marker] by given [markerId].
  /// It will return null if a [Marker] with
  /// the specified ID does not exist.
  @override
  Future<Marker?> getMarkerById(String markerId, [String? layerId]) async {
    _checkLayerExistence(layerId);
    final resp = await _channel.invokeMethod(ChannelMethods.getMarkerById, {
      "layerId": layerId,
      "markerId": markerId,
    });

    return resp != null ? Marker.fromJson(_getArgumentDictionary(resp)) : null;
  }

  /// Remove all markers on layer.
  @override
  Future<void> removeAllMarkers([String? layerId]) async {
    _checkLayerExistence(layerId);
    await _channel.invokeMethod(ChannelMethods.removeAllMarkers, {
      "layerId": layerId,
    });
  }

  /// Remove [Marker] by given [markerId].
  @override
  Future<void> removeMarkerById(String markerId, [String? layerId]) async {
    _checkLayerExistence(layerId);
    await _channel.invokeMethod(ChannelMethods.removeMarkerById, {
      "layerId": layerId,
      "markerId": markerId,
    });
  }

  /// It will overwrite the [Marker]
  /// with the specified [markerId] with a new one.
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

  /// Moves the map camera to the specified
  /// [CameraPosition] with a defined [duration] and [animationType].
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

  /// Set [MapTheme] to the map
  @override
  Future<void> setTheme(MapTheme theme) async {
    await _channel.invokeMethod(
      ChannelMethods.setTheme,
      {
        "theme": theme.name,
      },
    );
  }

  void _checkLayerExistence(String? layerId) {
    if (!layers.any((element) => element.layerId == layerId)) {
      throw LayerNotExistsException(
        message: "Layer with givien id {$layerId} not exists",
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
        case ChannelMethods.mapIsReady:
          _mapEventStreamController.add(const MapIsReadyEvent());
          break;
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
              markers: _getMarkersFromArguments(call.arguments["data"]),
            ),
          );
          break;
        case ChannelMethods.cameraOnMove:
          final arguments = _getArgumentDictionary(call.arguments);
          final cameraPosition = CameraPosition.fromJson(arguments);
          _cameraPositionStreamController.add(cameraPosition);
          _mapEventStreamController.add(
            CameraOnMoveEvent(
              cameraPosition: cameraPosition,
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
