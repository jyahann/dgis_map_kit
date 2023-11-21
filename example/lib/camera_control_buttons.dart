import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:flutter/material.dart';

class CameraControllButtons extends StatelessWidget {
  final DGisMapController mapController;

  const CameraControllButtons({
    super.key,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RawMaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            onPressed: () => mapController.moveCamera(
              CameraPosition(
                position: const Position(lat: 43.238949, long: 76.889709),
                zoom: 11,
              ),
            ),
            splashColor: Colors.white,
            fillColor: Colors.black.withOpacity(0.5),
            child: const Text(
              "Go to Almaty",
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          RawMaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            onPressed: () => mapController.moveCamera(
              CameraPosition(
                position: const Position(lat: 59.937500, long: 30.308611),
                zoom: 12,
              ),
            ),
            fillColor: Colors.black.withOpacity(0.5),
            splashColor: Colors.white,
            child: const Text(
              "Go to St Petersburg",
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
