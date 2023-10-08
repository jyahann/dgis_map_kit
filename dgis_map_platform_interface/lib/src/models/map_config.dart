class MapConfig {
  final String token;

  const MapConfig({
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }

  MapConfig.fromJson(Map<String, dynamic> json) : token = json["token"];
}
