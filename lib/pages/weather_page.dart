import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class WeatherInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _WeatherPageState extends State<WeatherPage> {
  late WeatherService weatherService;
  Weather? _weather;
  final TextEditingController _cityController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService('2e92e9dffff2887cf2e91ab428eed3f6');
    _loadWeatherWithLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Les services de localisation sont désactivés.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permission de localisation refusée');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permission de localisation refusée définitivement');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _loadWeatherWithLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final position = await _determinePosition();
      final weather = await weatherService.fetchWeather(
        lat: position.latitude,
        lon: position.longitude,
      );
      setState(() {
        _weather = weather;
        _cityController.text = weather.city;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _loadWeather([String? city]) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final weather = await weatherService.fetchWeather(
        city: city ?? _cityController.text,
      );
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement météo.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_weather != null)
            Image.asset(
              _weather!.backgroundImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          Container(
            color: Colors.black.withAlpha((0.5 * 255).toInt()),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cityController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Entrez une ville',
                              hintStyle: TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.white.withAlpha(30),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => _loadWeather(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _loading ? null : () => _loadWeather(),
                          child: _loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.search),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_error != null)
                      Text(
                        _error!,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                      ),
                    if (_weather == null && _error == null && !_loading)
                      const Expanded(
                        child: Center(
                          child: Text('Aucune donnée météo',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    if (_weather != null) ...[
                      Text(
                        _weather!.city,
                        style:
                            const TextStyle(fontSize: 32, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      WeatherInfoTile(
                        icon: FontAwesomeIcons.temperatureHalf,
                        label: "Température",
                        value: "${_weather!.temperature} °C",
                      ),
                      WeatherInfoTile(
                        icon: FontAwesomeIcons.droplet,
                        label: "Humidité",
                        value: "${_weather!.humidity} %",
                      ),
                      WeatherInfoTile(
                        icon: FontAwesomeIcons.wind,
                        label: "Vent",
                        value: "${_weather!.windSpeed} km/h",
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
