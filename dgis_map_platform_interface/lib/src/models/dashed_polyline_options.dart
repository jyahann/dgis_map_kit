class DashedPolylineOptions {
  final double dashLength;
  final double dashSpaceLength;

  DashedPolylineOptions({
    required this.dashLength,
    required this.dashSpaceLength,
  });

  Map<String, dynamic> toJson() => {
        "dashLength": dashLength,
        "dashSpaceLength": dashSpaceLength,
      };

  DashedPolylineOptions.fromJson(Map<String, dynamic> json)
      : dashLength = json["dashLength"],
        dashSpaceLength = json["dashSpaceLength"];
}
