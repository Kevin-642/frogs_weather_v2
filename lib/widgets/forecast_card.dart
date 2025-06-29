import 'package:flutter/material.dart';
import '../models/forecast_day.dart';

class ForecastCard extends StatelessWidget {
  final ForecastDay forecast;

  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 144,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  _formattedDate(forecast.date),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                flex: 2,
                child: Image.asset(
                  getLocalWeatherIcon(forecast.icon),
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  forecast.description,
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  'Min: ${forecast.minTemp.toStringAsFixed(0)}°  Max: ${forecast.maxTemp.toStringAsFixed(0)}°',
                  style: const TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formattedDate(DateTime date) {
    return '${_weekday(date.weekday)} ${date.day}/${date.month}';
  }

  String _weekday(int weekday) {
    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return days[(weekday - 1) % 7];
  }

  /// 🔁 Mapping des codes météo OpenWeather vers icônes locales
  String getLocalWeatherIcon(String iconCode) {
    const validIcons = {
      '01d',
      '01n',
      '02d',
      '02n',
      '03d',
      '03n',
      '04d',
      '04n',
      '09d',
      '09n',
      '10d',
      '10n',
      '11d',
      '11n',
      '13d',
      '13n',
      '50d',
      '50n',
    };

    return validIcons.contains(iconCode)
        ? 'assets/icons/$iconCode.png'
        : 'assets/icons/default.png';
  }
}
