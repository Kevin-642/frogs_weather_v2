import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';
import '../models/forecast_day.dart';
import '../constants/api_keys.dart';
import 'location_service.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class WeatherService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchWeather() async {
    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentPosition();
      return await fetchWeatherByLocation(
          position.latitude, position.longitude);
    } catch (e) {
      // Fallback sur Paris si géoloc échoue
      return fetchWeatherByCity('Paris');
    }
  }

  Future<Weather> fetchWeatherByCity(String city) async {
    final url =
        '$baseUrl/weather?q=$city&units=metric&lang=fr&appid=$openWeatherApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      logger.e('🛑 Erreur API météo ville: ${response.body}');
      throw Exception('Erreur lors du chargement de la météo');
    }
    final json = jsonDecode(response.body);
    return Weather.fromJson(json);
  }

  Future<Weather> fetchWeatherByLocation(double lat, double lon) async {
    final url =
        '$baseUrl/weather?lat=$lat&lon=$lon&units=metric&lang=fr&appid=$openWeatherApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      logger.e('🛑 Erreur API météo géoloc: ${response.body}');
      throw Exception('Erreur lors du chargement de la météo (géoloc)');
    }
    final json = jsonDecode(response.body);
    return Weather.fromJson(json);
  }

  Future<Forecast> fetchForecast(double lat, double lon) async {
    final url =
        '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&lang=fr&appid=$openWeatherApiKey';

    logger.i('📡 Appel prévision: $url');

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      logger.e('🛑 Erreur API prévisions: ${response.body}');
      throw Exception('Erreur lors du chargement des prévisions');
    }

    final json = jsonDecode(response.body);
    if (json['list'] == null || json['list'] is! List) {
      logger.e('🛑 JSON invalide : $json');
      throw Exception("Erreur : aucune donnée de prévision reçue.");
    }

    final forecastDays = _parseForecastData(json['list']);
    return Forecast(days: forecastDays);
  }

  List<ForecastDay> _parseForecastData(List<dynamic> data) {
    final Map<String, List<Map<String, dynamic>>> groupedByDay = {};

    for (var entry in data) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry['dt'] * 1000);
      final dayKey = DateTime(date.year, date.month, date.day).toString();

      groupedByDay.putIfAbsent(dayKey, () => []).add(entry);
    }

    return groupedByDay.entries.map((entry) {
      final date = DateTime.parse(entry.key);
      final entries = entry.value;

      double minTemp = entries.first['main']['temp_min']?.toDouble() ?? 0;
      double maxTemp = entries.first['main']['temp_max']?.toDouble() ?? 0;
      String description = '';
      String icon = '';

      for (var e in entries) {
        final main = e['main'];
        final weather = e['weather']?[0];

        if (main != null) {
          final tempMin = main['temp_min']?.toDouble() ?? minTemp;
          final tempMax = main['temp_max']?.toDouble() ?? maxTemp;
          minTemp = tempMin < minTemp ? tempMin : minTemp;
          maxTemp = tempMax > maxTemp ? tempMax : maxTemp;
        }

        if (weather != null && description.isEmpty) {
          description = weather['description'] ?? '';
          icon = weather['icon'] ?? '01d';
        }
      }

      return ForecastDay(
        date: date,
        minTemp: minTemp,
        maxTemp: maxTemp,
        description: description,
        icon: icon,
      );
    }).toList();
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
