import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> fetchWeather({String? city, double? lat, double? lon}) async {
    Uri url;
    if (lat != null && lon != null) {
      url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=fr',
      );
    } else {
      final cityName = city ?? 'Toulouse';
      url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric&lang=fr',
      );
    }

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception(
          'Erreur lors de la récupération de la météo (${response.statusCode})');
    }
  }
}
