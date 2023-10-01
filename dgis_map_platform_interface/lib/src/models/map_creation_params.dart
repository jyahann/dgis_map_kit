class MapCreationParams {
  final String token;

  const MapCreationParams({
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }

  MapCreationParams.fromJson(Map<String, dynamic> json) : token = json["token"];
}
