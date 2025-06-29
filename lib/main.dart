import 'package:flutter/material.dart';
import 'pages/weather_page.dart';

void main() {
  runApp(const FrogsWeatherApp());
}

class FrogsWeatherApp extends StatelessWidget {
  const FrogsWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FrogsWeather',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherPage(),
    );
  }
}
