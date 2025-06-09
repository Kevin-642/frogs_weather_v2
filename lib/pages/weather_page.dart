import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late WeatherService weatherService;
  Weather? _weather;
  bool _loading = false;
  String? _error;

  bool _searchMode = false;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    weatherService = WeatherService('2e92e9dffff2887cf2e91ab428eed3f6');
    _loadWeather(); // Chargement automatique au lancement
  }

  Future<void> _loadWeather([String? city]) async {
    setState(() {
      _loading = true;
      _error = null;
      if (city != null) _cityController.text = city;
    });

    try {
      String cityToSearch = city ?? _cityController.text.trim();

      // Si aucune ville saisie, on tente la géolocalisation
      if (cityToSearch.isEmpty) {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception('La géolocalisation est désactivée.');
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception('Permission de localisation refusée');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          throw Exception('Permission refusée définitivement');
        }

        final Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        final List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isEmpty || placemarks.first.locality == null) {
          throw Exception("Impossible de déterminer la ville.");
        }

        cityToSearch = placemarks.first.locality!;
      }

      final weather = await weatherService.fetchWeather(city: cityToSearch);

      setState(() {
        _weather = weather;
        _cityController.text = cityToSearch;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur météo : ${e.toString()}';
        _weather = null;
      });
    } finally {
      setState(() {
        _loading = false;
        _searchMode = false;
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ],
    );
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
            )
          else
            Container(color: Colors.blueGrey.shade900),
          Container(color: Colors.black.withAlpha(150)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      _searchMode
                          ? Expanded(
                              child: TextField(
                                autofocus: true,
                                controller: _cityController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Entrez une ville',
                                  hintStyle:
                                      const TextStyle(color: Colors.white54),
                                  filled: true,
                                  fillColor: Colors.white.withAlpha(30),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _searchMode = false;
                                        _cityController.clear();
                                      });
                                    },
                                  ),
                                ),
                                onSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    _loadWeather(value.trim());
                                  }
                                },
                              ),
                            )
                          : IconButton(
                              icon:
                                  const Icon(Icons.search, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _searchMode = true;
                                });
                              },
                            ),
                      Expanded(
                        child: Center(
                          child: Text(
                            _weather?.city ?? 'Chargement...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: _loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _loading ? null : () => _loadWeather(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  if (_weather != null) ...[
                    Text(
                      '${_weather!.temperature.toStringAsFixed(1)} °C',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _weather!.description.capitalize(),
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 40),
                  if (_weather != null)
                    Expanded(
                      child: Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 40,
                          runSpacing: 24,
                          children: [
                            _buildInfoTile(
                                Icons.thermostat_outlined,
                                'Ressentie',
                                '${_weather!.feelsLike.toStringAsFixed(1)} °C'),
                            _buildInfoTile(FontAwesomeIcons.droplet, 'Humidité',
                                '${_weather!.humidity} %'),
                            _buildInfoTile(FontAwesomeIcons.wind, 'Vent',
                                '${_weather!.windSpeed.toStringAsFixed(1)} km/h'),
                            _buildInfoTile(FontAwesomeIcons.gauge, 'Pression',
                                '${_weather!.pressure} hPa'),
                            _buildInfoTile(FontAwesomeIcons.cloudRain, 'Pluie',
                                '${_weather!.rainVolumeLastHour} mm'),
                          ],
                        ),
                      ),
                    ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        _error!,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                      ),
                    ),
                  if (!_loading && _weather == null && _error == null)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Aucune donnée météo',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
