class Weather {
  final String city;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final DateTime sunrise;
  final DateTime sunset;
  final double latitude;
  final double longitude;
  final String icon;
  final double feelsLike;
  final int pressure;
  final double precipitationProbability;

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.latitude,
    required this.longitude,
    required this.icon,
    required this.feelsLike,
    required this.pressure,
    required this.precipitationProbability,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      pressure: json['main']['pressure'] as int,
      precipitationProbability:
          json.containsKey('pop') ? (json['pop'] as num).toDouble() * 100 : 0.0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunrise'] as int) * 1000,
        isUtc: true,
      ).toLocal(),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunset'] as int) * 1000,
        isUtc: true,
      ).toLocal(),
      latitude: (json['coord']['lat'] as num).toDouble(),
      longitude: (json['coord']['lon'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }

  String getWeatherBackground(String condition) {
    final normalized = condition.toLowerCase();

    if (normalized.contains('dégagé') || normalized.contains('soleil')) {
      return 'sunny.jpg';
    }
    if (normalized.contains('nuage')) {
      return 'cloudy.jpg';
    }
    if (normalized.contains('pluie') || normalized.contains('bruine')) {
      return 'rainy.jpg';
    }
    if (normalized.contains('orage') || normalized.contains('foudre')) {
      return 'stormy.jpg';
    }
    if (normalized.contains('brouillard') ||
        normalized.contains('brume') ||
        normalized.contains('brumeux')) {
      return 'mist.jpg';
    }
    if (normalized.contains('neige')) {
      return 'snowy.jpg';
    }

    return 'default.jpg';
  }
}
