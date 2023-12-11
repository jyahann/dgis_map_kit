import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';

enum MapTheme { light, dark }

/// The basic map configuration required when creating it.
class MapConfig {
  /// 2Gis Android | IOS Sdk token
  final String keyFile;

  /// Initial camera position on the map.
  final CameraPosition initialCameraPosition;

  /// Initial map layers on the map.
  final List<MapLayer> layers;

  /// Map theme.
  final MapTheme theme;

  const MapConfig({
    required this.keyFile,
    required this.initialCameraPosition,
    required this.layers,
    required this.theme,
  });

  Map<String, dynamic> toJson() {
    return {
      'keyFile': keyFile,
      'initialCameraPosition': initialCameraPosition.toJson(),
      'layers': layers.map((layer) => layer.toJson()).toList(),
      'theme': theme.name,
    };
  }
}
