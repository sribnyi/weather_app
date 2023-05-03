/// main screen to display weather data
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../model/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:geocoding/geocoding.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather? weatherData;
  WeatherService weatherService = WeatherService();
  final Logger logger = Logger();

  /// THESE ARE THE HARDCODED COORDINATES
  final double latitude = 59.44;
  final double longitude = 24.75;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  /// get city name from the coordinates
  Future<String> getNameFromCoordinates(double latitude,
      double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude);
      Placemark placemark = placemarks.first;
      return placemark.locality ?? 'unknown';
    } catch (error) {
      print('Error converting coordinates to city name: $error');
      return 'Unknown';
    }
  }

  /// currently hardcoded coordinates unfortunately
  Future<void> fetchWeatherData() async {
    try {
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
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.1),

            /// Current temperature
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.6,
              height: MediaQuery
                  .of(context)
                  .size
                  .width * 0.6,
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

            /// weather description (sunny, windy etc)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                weatherData != null
                    ? weatherData!.weatherDescription
                    : 'Loading...',
                style: const TextStyle(fontSize: 18),
              ),
            ),

            /// location name, right now detects the location name based on
            /// hardcoded latitude and logitude
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child:
              FutureBuilder<String>(
                future: getNameFromCoordinates(latitude, longitude),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      snapshot.data ?? 'Unknown',
                      style: const TextStyle(fontSize: 24),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
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
