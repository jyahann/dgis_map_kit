class Position {
  final double lat;
  final double long;

  const Position({
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
    };
  }

  Position.fromJson(Map<String, dynamic> json)
      : lat = json["lat"],
        long = json["long"];
}
