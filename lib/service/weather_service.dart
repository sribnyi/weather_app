/// this is a class for communication with the open-meteo API
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:weather_app/model/weather_model.dart';

class WeatherService {
  final String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Weather> getWeatherByLocation(
      double latitude, double longitude) async {
    final String requestUrl =
        '$_baseUrl?latitude=$latitude&longitude=$longitude&current_weather=true';

    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      Weather weather = Weather.fromJson({
        'location': '${responseBody['latitude']}, ${responseBody['longitude']}',
        'temperature_2m': responseBody['current_weather']['temperature'],
        'wind_speed_10m': responseBody['current_weather']['windspeed'],
        'weathercode': responseBody['current_weather']['weathercode']
      });

      return weather;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
