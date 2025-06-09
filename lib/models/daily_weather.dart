class DailyWeather {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;

  DailyWeather({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMin: json['temp']['min'].toDouble(),
      tempMax: json['temp']['max'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
