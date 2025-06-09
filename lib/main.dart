import 'package:flutter/material.dart';
import 'pages/weather_page.dart';

void main() {
  runApp(const FrogWeatherApp());
}

class FrogWeatherApp extends StatelessWidget {
  const FrogWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Le Journal Météo des Grenouilles',
      theme: ThemeData.dark(),
      home: const WeatherPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
