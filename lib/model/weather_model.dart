class Weather {
  final String location;
  final double currentTemperature;
  final double windSpeed;

  Weather({required this.location, required this.currentTemperature, required this.windSpeed});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['location'],
      currentTemperature: json['temperature_2m'].toDouble(),
      windSpeed: json['wind_speed_10m'].toDouble(),
    );
  }
}
