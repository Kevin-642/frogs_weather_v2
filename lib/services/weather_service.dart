import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> fetchWeather({String city = 'Toulouse'}) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=fr',
    );

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
