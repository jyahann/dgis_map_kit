import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Map widget creation options.
@immutable
class MapWidgetOptions {
  final MessageCodec<dynamic> creationParamsCodec;

  final TextDirection textDirection;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  const MapWidgetOptions({
    required this.textDirection,
    this.creationParamsCodec = const StandardMessageCodec(),
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
  });
}
