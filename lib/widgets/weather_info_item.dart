import 'package:flutter/material.dart';

class WeatherInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
