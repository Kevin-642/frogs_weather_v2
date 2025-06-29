class ForecastDay {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String icon;

  ForecastDay({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.icon,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weatherList = json['weather'];

    if (main == null || weatherList == null || weatherList.isEmpty) {
      throw Exception('Entrée de prévision invalide ou incomplète');
    }

    return ForecastDay(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      minTemp: (main['temp_min'] ?? 0).toDouble(),
      maxTemp: (main['temp_max'] ?? 0).toDouble(),
      description: weatherList[0]['description'] ?? 'Inconnu',
      icon: weatherList[0]['icon'] ?? '01d',
    );
  }
}
