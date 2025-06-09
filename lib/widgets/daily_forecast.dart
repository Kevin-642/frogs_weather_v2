import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/daily_weather.dart';

class DailyForecast extends StatelessWidget {
  final List<DailyWeather> forecasts;

  const DailyForecast({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prévisions sur 7 jours',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              final forecast = forecasts[index];
              return _DailyCard(forecast: forecast);
            },
          ),
        ),
      ],
    );
  }
}

class _DailyCard extends StatelessWidget {
  final DailyWeather forecast;

  const _DailyCard({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final date =
        DateFormat.EEEE('fr_FR').format(forecast.date); // Lundi, Mardi…
    final iconUrl = 'https://openweathermap.org/img/wn/${forecast.icon}@2x.png';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
            Image.network(iconUrl, width: 50, height: 50),
            Text('${forecast.tempMax.toInt()}° / ${forecast.tempMin.toInt()}°'),
            Text(
              forecast.description,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
