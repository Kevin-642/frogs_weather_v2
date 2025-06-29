import 'forecast_day.dart';

class Forecast {
  final List<ForecastDay> days;

  Forecast({required this.days});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'];
    if (json['list'] is List) {
      throw Exception("Prévisions non disponibles");
    }

    final Map<String, ForecastDay> dailyMap = {};

    for (var item in list) {
      try {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final dayKey = DateTime(dateTime.year, dateTime.month, dateTime.day)
            .toIso8601String();

        // Ne garder qu'une prévision par jour (ex : la première)
        if (!dailyMap.containsKey(dayKey)) {
          dailyMap[dayKey] = ForecastDay.fromJson(item);
        }
      } catch (_) {
        // Ignore les entrées invalides
      }
    }

    return Forecast(days: dailyMap.values.toList());
  }
}
