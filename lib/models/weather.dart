class Weather {
  final String city;
  final double temperature;
  final String description;
  final String iconCode;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final double rainVolumeLastHour;

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.rainVolumeLastHour,
  });

  // Ajout d'une méthode pour mapper iconCode à image locale
  String get backgroundImage {
    switch (iconCode) {
      case '01d':
        return 'assets/images/sunny.jpg';
      case '01n':
        return 'assets/images/sunny.jpg'; // tu peux changer pour une version nuit si tu en as
      case '02d':
      case '03d':
      case '04d':
      case '02n':
      case '03n':
      case '04n':
        return 'assets/images/cloudy.jpg';
      case '09d':
      case '10d':
      case '09n':
      case '10n':
        return 'assets/images/rainy.jpg';
      case '11d':
      case '11n':
        return 'assets/images/stormy.jpg';
      case '13d':
      case '13n':
        return 'assets/images/snowy.jpg';
      case '50d':
      case '50n':
        return 'assets/images/mist.jpg';
      default:
        return 'assets/images/default.jpg';
    }
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? 'Inconnue',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'],
      rainVolumeLastHour:
          json.containsKey('rain') && json['rain'].containsKey('1h')
              ? (json['rain']['1h'] as num).toDouble()
              : 0,
    );
  }
}
