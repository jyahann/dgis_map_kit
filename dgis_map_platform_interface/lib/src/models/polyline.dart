import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:dgis_map_platform_interface/src/models/dashed_polyline_options.dart';
import 'package:dgis_map_platform_interface/src/models/gradient_polyline_options.dart';
import 'package:flutter/material.dart';

class Polyline {
  final int? id;
  final List<Position> points;
  final double width;
  final Color color;
  final double erasedPart;
  final DashedPolylineOptions? dashedPolylineOptions;
  final GradientPolylineOptions? gradientPolylineOptions;
  final bool visible;

  /// The data that will be saved and retrieved in map events.
  final Map<String, dynamic>? data;

  final int zIndex;
  final int? levelId;

  Polyline({
    this.id,
    required this.points,
    this.width = 1.0,
    required this.color,
    this.erasedPart = 0,
    this.visible = true,
    this.data,
    this.zIndex = 0,
    this.levelId,
  })  : dashedPolylineOptions = null,
        gradientPolylineOptions = null;

  Polyline.dashed({
    this.id,
    required this.points,
    this.width = 1.0,
    required this.color,
    this.erasedPart = 0,
    this.visible = true,
    this.data,
    this.zIndex = 0,
    this.levelId,
    required DashedPolylineOptions this.dashedPolylineOptions,
  }) : gradientPolylineOptions = null;

  Polyline.gradient({
    this.id,
    required this.points,
    this.width = 1.0,
    required this.color,
    this.erasedPart = 0,
    this.visible = true,
    this.data,
    this.zIndex = 0,
    this.levelId,
    required GradientPolylineOptions this.gradientPolylineOptions,
  }) : dashedPolylineOptions = null;

  Map<String, dynamic> toJson() => {
        "id": id,
        "points": points.map(
          (e) => e.toJson(),
        ),
        "width": width,
        "color": color.value,
        "erasedPart": erasedPart,
        "visible": visible,
        "data": data,
        "zIndex": zIndex,
        "levelId": levelId,
        "gradientPolylineOptions": gradientPolylineOptions?.toJson(),
        "dashedPolylineOptions": dashedPolylineOptions?.toJson(),
      };

  Polyline.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        points = (json["points"] as List<dynamic>)
            .map(
              (e) => Position.fromJson(
                (e as Map<Object?, Object?>).cast<String, dynamic>(),
              ),
            )
            .toList(),
        width = json["width"],
        color = json["color"],
        erasedPart = json["erasedPart"],
        visible = json["visible"],
        zIndex = json["zIndex"],
        levelId = json["levelId"],
        gradientPolylineOptions = json["gradientPolylineOptions"] != null
            ? GradientPolylineOptions.fromJson(
                (json["gradientPolylineOptions"] as Map<Object?, Object?>)
                    .cast<String, dynamic>(),
              )
            : null,
        dashedPolylineOptions = json["dashedPolylineOptions"] != null
            ? DashedPolylineOptions.fromJson(
                (json["dashedPolylineOptions"] as Map<Object?, Object?>)
                    .cast<String, dynamic>(),
              )
            : null,
        data = json["data"] == null
            ? null
            : (json["data"] as Map<Object?, Object?>).cast<String, dynamic>();
}
