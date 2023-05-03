/// main screen to display weather data
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../model/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final Logger logger = Logger();
  Weather? weatherData;
  WeatherService weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      double latitude = 59.44;
      double longitude = 24.75;
      Weather fetchedWeatherData =
          await weatherService.getWeatherByLocation(latitude, longitude);
      setState(() {
        weatherData = fetchedWeatherData;
      });
    } catch (error) {
      logger.e('Error fetching weather data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),

            /// Current temperature
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 4),
              ),
              child: Center(
                child: Text(
                  weatherData != null
                      ? '${weatherData!.currentTemperature}°'
                      : 'Loading...',
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            /// location name
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                weatherData != null ? weatherData!.location : 'Loading...',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            /// Change location hint
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                onTap: () {
                  /// todo - handle this button
                },
                child: const Text(
                  'Change location',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),

            /// Other weather data
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Wind Speed',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(weatherData != null
                          ? '${weatherData!.windSpeed} m/s'
                          : 'Loading...'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
