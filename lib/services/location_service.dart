import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('La localisation est désactivée.');
    }

    // Vérifie les permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('La permission de localisation a été refusée.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'La permission de localisation est définitivement refusée.');
    }

    // Récupère la position
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }
}
