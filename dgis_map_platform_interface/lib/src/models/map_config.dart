import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

enum MapTheme { LIGHT, DARK }

class MapConfig {
  final String token;
  final CameraPosition initialCameraPosition;
  final List<MapLayer> layers;
  final MapTheme theme;
  final bool enableMyLocation;

  const MapConfig({
    required this.token,
    required this.initialCameraPosition,
    required this.layers,
    required this.theme,
    required this.enableMyLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'initialCameraPosition': initialCameraPosition.toJson(),
      'enableMyLocation': enableMyLocation,
      'layers': layers
          .map(
            (layer) => {
              "isClusterer": layer is ClustererLayer,
              "layer": layer.toJson()
            },
          )
          .toList(),
      'theme': theme.name,
    };
  }
}
