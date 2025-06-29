import 'package:flutter/material.dart';
import 'weather_info_item.dart';

class WeatherInfoTile extends StatelessWidget {
  final String humidity;
  final String wind;
  final String sunrise;
  final String sunset;

  const WeatherInfoTile({
    super.key,
    required this.humidity,
    required this.wind,
    required this.sunrise,
    required this.sunset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          WeatherInfoItem(
              icon: Icons.water_drop, label: 'Humidité', value: '$humidity%'),
          WeatherInfoItem(icon: Icons.air, label: 'Vent', value: '$wind km/h'),
          WeatherInfoItem(icon: Icons.wb_sunny, label: 'Lever', value: sunrise),
          WeatherInfoItem(
              icon: Icons.nightlight_round, label: 'Coucher', value: sunset),
        ],
      ),
    );
  }
}
