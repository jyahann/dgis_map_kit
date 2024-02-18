import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:flutter/material.dart';

enum ZoomDirection {
  increase,
  decrease,
}

class MapNavigation extends StatelessWidget {
  final DGisMapController mapController;

  const MapNavigation({
    super.key,
    required this.mapController,
  });

  Future zoom(ZoomDirection direction) async {
    final getZoom = direction == ZoomDirection.increase
        ? (double zoom) => zoom + 1.5
        : (double zoom) => zoom - 1.5;
    const duration = Duration(milliseconds: 200);
    final cameraPosition = mapController.currentCameraPosition;

    await mapController.moveCamera(
      CameraPosition(
        position: cameraPosition.position,
        zoom: getZoom(
          cameraPosition.zoom,
        ),
      ),
      duration: duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            elevation: 2.0,
            shape: const CircleBorder(),
            color: Colors.black.withOpacity(0.9),
            child: InkWell(
              onTap: () async=> await zoom(ZoomDirection.increase),
              borderRadius: BorderRadius.circular(20.0),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add_rounded,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Material(
            elevation: 2.0,
            shape: const CircleBorder(),
            color: Colors.black.withOpacity(0.9),
            child: InkWell(
              onTap: () => zoom(ZoomDirection.decrease),
              borderRadius: BorderRadius.circular(20.0),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.remove_rounded,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
