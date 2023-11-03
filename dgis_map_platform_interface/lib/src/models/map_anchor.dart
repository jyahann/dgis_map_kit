// Map object's anchor.
class MapAnchor {
  final double x;
  final double y;

  const MapAnchor(this.x, this.y);

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  MapAnchor.fromJson(Map<String, dynamic> json)
      : x = json["x"],
        y = json["y"];
}
