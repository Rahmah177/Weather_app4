import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'package:intl/intl.dart';

class Forecast extends StatelessWidget {
  const Forecast({super.key, required this.weatherModel});

  final WeatherModel weatherModel;

  @override
  Widget build(BuildContext context) {
    String formatDay(String dateString) {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('EEEE').format(date);
    }

    String formatTime(String dateString) {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('h:mm a').format(date);
    }

    return Card(
      color: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDay(weatherModel.date),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatTime(weatherModel.date),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${weatherModel.temp.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Image.network(
                  'https://openweathermap.org/img/wn/${weatherModel.iconCode}@2x.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 2),
                Text(
                  weatherModel.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
