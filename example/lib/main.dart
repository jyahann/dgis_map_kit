import 'dart:async';

import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:dgis_map_kit_example/camera_control_buttons.dart';
import 'package:dgis_map_kit_example/map_navigation.dart';
import 'package:dgis_map_kit_example/theme_picker.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as log;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const Color primaryColor = Color(0xff11C775);

  DGisMapController? _controller;
  final Completer<bool> _isMapReadyCompleter = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log.log("starting example");

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: Alignment.centerRight,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: DGisMap(
                token: "505d338f-975b-49e0-b4df-04c17dfa0ac3",
                layers: [
                  MapLayer.withClustering(
                    builder: (markers) => MapClusterer(
                      icon: "assets/map_cluster_pin.png",
                      iconOptions: MapIconOptions(
                        text: markers.length.toString(),
                        textStyle: const MapIconTextStyle(
                          fontSize: 13.0,
                          color: primaryColor,
                          strokeColor: primaryColor,
                          textPlacement: MapIconTextPlacement.TOP_CENTER,
                          textOffset: -20.0,
                        ),
                      ),
                    ),
                    maxZoom: 20.0,
                    minDistance: 100.0,
                    onTap: (markers, _) async {
                      final cameraPosition = _controller?.currentCameraPosition;
                      if (cameraPosition != null) {
                        final landmark = markers.first;

                        _controller?.moveCamera(
                          CameraPosition(
                            position: landmark.position,
                            zoom: cameraPosition.zoom + 2,
                          ),
                          duration: const Duration(milliseconds: 300),
                          animationType: CameraAnimationType.DEFAULT,
                        );
                      }
                    },
                  ),
                ],
                theme: MapTheme.DARK,
                enableUserLocation: true,
                onUserLocationChanged: (position) {
                  log.log(
                    "User location changed: ${position.lat} ${position.long}",
                  );

                  return Marker(
                    position: position,
                    icon: "assets/user_location.png",
                    iconOptions: const MapIconOptions(size: 40.0),
                  );
                },
                initialCameraPosition: CameraPosition(
                  position: const Position(
                    lat: 51.169392,
                    long: 71.449074,
                  ),
                  zoom: 12,
                ),
                mapOnTap: (position) {
                  _controller?.moveCamera(
                    CameraPosition(position: position, zoom: 18.0),
                    duration: const Duration(milliseconds: 400),
                    animationType: CameraAnimationType.SHOW_BOTH_POSITIONS,
                  );

                  _controller?.markersController.addMarker(
                    Marker(
                      id: "user_marker",
                      position: position,
                      icon: "assets/map_pin.png",
                    ),
                    "user_markers",
                  );
                },
                markerOnTap: (marker, _) => _controller?.moveCamera(
                  CameraPosition(
                    position: marker.position,
                    zoom: 18,
                  ),
                  duration: const Duration(milliseconds: 600),
                ),
                mapOnReady: () {
                  _isMapReadyCompleter.complete(true);

                  _controller?.markersController.addMarkers(
                    const [
                      Marker(
                        id: "id",
                        icon: "assets/map_pin.png",
                        position: Position(
                          lat: 51.132905927930146,
                          long: 71.42752647399904,
                        ),
                        data: {"data": 2},
                      ),
                      Marker(
                        icon: "assets/map_pin.png",
                        position: Position(
                          lat: 51.13601624568085,
                          long: 71.43458604812623,
                        ),
                      ),
                      Marker(
                        icon: "assets/map_pin.png",
                        position: Position(
                          lat: 51.13601628568085,
                          long: 71.43659604812623,
                        ),
                      ),
                    ],
                  );

                  _controller
                      ?.addLayer(const MapLayer(layerId: "user_markers"));
                },
                mapOnCreated: (controller) {
                  _controller = controller;
                },
              ),
            ),
            FutureBuilder(
              future: _isMapReadyCompleter.future,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data == true &&
                    _controller != null) {
                  return MapNavigation(mapController: _controller!);
                }
                return const SizedBox.shrink();
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FutureBuilder(
                    future: _isMapReadyCompleter.future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data == true &&
                          _controller != null) {
                        return CameraControllButtons(
                            mapController: _controller!);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  ThemePicker(
                    onThemeChange: (value) async {
                      if (await _isMapReadyCompleter.future) {
                        _controller!.setTheme(value);
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
