import 'dart:async';

import 'package:dgis_map_kit/src/controller/dgis_map_controller.dart';
import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:flutter/material.dart';

typedef MapCreatedCallback = void Function(DGisMapController controller);

class DGisMap extends StatefulWidget {
  late final MapConfig mapConfig;

  final MapCreatedCallback? onMapCreated;

  DGisMap({
    super.key,
    required String token,
    this.onMapCreated,
  }) : mapConfig = MapConfig(token: token);

  @override
  State<DGisMap> createState() => _DGisMapState();
}

class _DGisMapState extends State<DGisMap> {
  final Completer<DGisMapController> _controller =
      Completer<DGisMapController>();

  late DGisMapPlatform _dGisMapPlatform;

  @override
  void initState() {
    _dGisMapPlatform = DGisMapPlatform.createInstance(
      mapConfig: widget.mapConfig,
      widgetOptions: const MapWidgetOptions(
        textDirection: TextDirection.ltr,
      ),
    );
    // TODO: implement initState
    super.initState();
  }

  Future<void> onPlatformViewCreated() async {
    final controller = DGisMapController(
      dGisMapPlatform: _dGisMapPlatform,
    );
    _controller.complete(controller);

    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _dGisMapPlatform.buildView(
      onCreated: onPlatformViewCreated,
    );
  }
}
