import 'package:flutter/material.dart';

class ForecastDay {}

class HorizontalForecastList extends StatelessWidget {
  final List<ForecastDay> forecastDays;

  const HorizontalForecastList({super.key, required this.forecastDays});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastDays.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Day ${index + 1}'),
            ),
          );
        },
      ),
    );
  }
}

class DailyForecast extends StatelessWidget {
  final List<ForecastDay> forecast;

  const DailyForecast({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Prévisions sur plusieurs jours',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        HorizontalForecastList(forecastDays: forecast),
      ],
    );
  }
}
