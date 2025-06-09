class Weather {
  final String city;
  final String backgroundImage;
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
    required this.backgroundImage,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.rainVolumeLastHour,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'] ?? 'Inconnue',
      backgroundImage:
          'assets/images/${_mapIconToImage(json['weather'][0]['icon'])}',
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

// Pour mapper les icônes météo OpenWeather aux fichiers images locales
String _mapIconToImage(String iconCode) {
  switch (iconCode) {
    case '01d':
    case '01n':
      return 'sunny.jpg';
    case '02d':
    case '02n':
      return 'cloudy.jpg';
    case '03d':
    case '03n':
    case '04d':
    case '04n':
      return 'cloudy.jpg';
    case '09d':
    case '09n':
      return 'rainy.jpg';
    case '10d':
    case '10n':
      return 'rainy.jpg';
    case '11d':
    case '11n':
      return 'stormy.jpg';
    case '13d':
    case '13n':
      return 'snowy.jpg';
    case '50d':
    case '50n':
      return 'mist.jpg';
    default:
      return 'default.jpg';
  }
}
