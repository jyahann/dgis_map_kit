import 'package:dgis_map_kit/dgis_map_kit.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: DGisMap.withClustering(
          token: "505d338f-975b-49e0-b4df-04c17dfa0ac3",
          clustererBuilder: (markers) => MapClusterer(
            icon: "assets/map_pin.png",
            iconOptions: MapIconOptions(
                text: "${markers.length} objects",
                textStyle: const MapIconTextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                  textPlacement: MapIconTextPlacement.RIGHT_CENTER,
                )),
          ),
          clusterOnTap: (markers) {
            log.log("Cluster on tap: ${markers.length} objects");
          },
          onMapCreated: (controller) {
            controller.addMarkers(
              const [
                Marker(
                  icon: "assets/map_pin.png",
                  position: Position(
                    lat: 51.132905927930146,
                    long: 71.42752647399904,
                  ),
                ),
                Marker(
                  icon: "assets/map_pin.png",
                  position: Position(
                    lat: 51.13601624568085,
                    long: 71.43458604812623,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
