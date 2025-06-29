import 'package:flutter/material.dart';
import '../models/forecast_day.dart';
import 'forecast_card.dart';

class HorizontalForecastList extends StatelessWidget {
  final List<ForecastDay> forecastDays;

  const HorizontalForecastList({super.key, required this.forecastDays});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // Hauteur adaptée à ForecastCard (144 + padding)
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastDays.length,
        itemBuilder: (context, index) {
          return ForecastCard(forecast: forecastDays[index]);
        },
      ),
    );
  }
}
