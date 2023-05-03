class Weather {
  final String location;
  final double currentTemperature;
  final double windSpeed;
  final String weatherDescription;

  Weather(
      {required this.location,
      required this.currentTemperature,
      required this.windSpeed,
      required this.weatherDescription});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['location'],
      currentTemperature: json['temperature_2m'].toDouble(),
      windSpeed: json['wind_speed_10m'].toDouble(),
      weatherDescription: Weather.weatherCodeToDescription(json['weathercode']),
    );
  }

  static String weatherCodeToDescription(int weatherCode) {
    switch (weatherCode) {
      case 1:
        return 'Clear sky';
      case 2:
        return 'Few clouds';
      case 3:
        return 'Scattered clouds';
      case 4:
        return 'Broken clouds';
      case 5:
        return 'Shower rain';
      case 6:
        return 'Rain';
      case 7:
        return 'Thunderstorm';
      case 8:
        return 'Snow';
      case 9:
        return 'Mist';
      default:
        return 'Unknown';
    }
  }
}
