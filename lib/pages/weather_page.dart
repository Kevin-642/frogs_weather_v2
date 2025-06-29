import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../widgets/horizontal_forecast_list.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  final _locationService = LocationService();
  final _cityController = TextEditingController();

  Weather? _weather;
  Forecast? _forecast;
  String? _error;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadWeatherByLocation();
  }

  Future<void> _loadWeatherByLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      final weather = await _weatherService.fetchWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      final forecast = await _weatherService.fetchForecast(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _weather = weather;
        _forecast = forecast;
        _error = null;
      });
    } catch (e) {
      debugPrint('Erreur météo localisée : $e');
      setState(() {
        _error = 'Impossible de charger la météo locale.';
      });
    }
  }

  Future<void> _searchCity() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;

    try {
      final weather = await _weatherService.fetchWeatherByCity(city);
      final forecast = await _weatherService.fetchForecast(
        weather.latitude,
        weather.longitude,
      );
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _error = null;
        _isSearching = false;
      });
      _cityController.clear();
    } catch (e) {
      debugPrint('Erreur recherche ville : $e');
      setState(() {
        _error = 'Ville non trouvée.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _weather == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/${_weatherService.getWeatherBackground(_weather!.description)}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _isSearching ? _buildSearchBar() : _buildTopBar(),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            const SizedBox(height: 24),
                            _buildMainWeather(),
                            const SizedBox(height: 24),
                            _buildWeatherDetailsGrid(),
                            const SizedBox(height: 24),
                            if (_forecast != null) _buildForecast(),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: TextField(
        controller: _cityController,
        autofocus: true,
        onSubmitted: (_) => _searchCity(),
        decoration: InputDecoration(
          hintText: 'Rechercher une ville',
          filled: true,
          fillColor: Colors.white.withAlpha(230),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchCity,
          ),
          prefixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _error = null;
              });
              _cityController.clear();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: () {
              setState(() {
                _isSearching = true;
                _error = null;
              });
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                _weather?.city ?? 'Chargement...',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
            onPressed: _loadWeatherByLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeather() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${_weather!.temperature.toStringAsFixed(1)}°C',
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 8,
                color: Colors.black54,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _weather!.description,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            shadows: [
              Shadow(
                blurRadius: 6,
                color: Colors.black38,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetailsGrid() {
    if (_weather == null) return const SizedBox.shrink();

    Widget detailItem(IconData icon, String label, Color color) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      );
    }

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1,
      ),
      children: [
        detailItem(
            Icons.thermostat,
            'Ressenti\n${_weather!.feelsLike.toStringAsFixed(1)}°C',
            Colors.orangeAccent),
        detailItem(Icons.water_drop, 'Humidité\n${_weather!.humidity}%',
            Colors.lightBlueAccent),
        detailItem(
            Icons.air, 'Vent\n${_weather!.windSpeed} km/h', Colors.greenAccent),
        detailItem(Icons.speed, 'Pression\n${_weather!.pressure} hPa',
            Colors.amberAccent),
        detailItem(
            Icons.umbrella,
            'Pluie\n${_weather!.precipitationProbability.toStringAsFixed(0)}%',
            Colors.blueAccent),
        detailItem(Icons.wb_sunny, 'Lever\n${_formatTime(_weather!.sunrise)}',
            Colors.yellowAccent),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildForecast() {
    return SizedBox(
      height: 180,
      child: HorizontalForecastList(forecastDays: _forecast!.days),
    );
  }
}
