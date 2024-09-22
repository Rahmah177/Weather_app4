import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/WeatherStateMang.dart';
import 'forecast_Card.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade300, Colors.green.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  width: double.infinity,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter city name',
                      hintStyle: const TextStyle(color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          final cityName = _searchController.text.trim();
                          if (cityName.isNotEmpty) {
                            Provider.of<WeatherDataModel>(context,
                                    listen: false)
                                .updateCity(cityName);
                            _searchController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Consumer<WeatherDataModel>(
                  builder: (context, weatherDataModel, child) {
                    final cityName = weatherDataModel.city;

                    return FutureBuilder<Map<String, dynamic>?>(
                      future:
                          Provider.of<WeatherService>(context, listen: false)
                              .fetchWeather(cityName: cityName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final data = snapshot.data!;
                          final currentWeather =
                              WeatherModel.fromJson(data['currentWeather']);
                          final forecastWeather =
                              (data['forecastWeather'] as List)
                                  .map((item) => WeatherModel.fromJson(item))
                                  .toList();

                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.lightBlue.shade100
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 15,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 24, horizontal: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('EEEE, MMM d').format(
                                          DateTime.parse(currentWeather.date)),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 28, color: Colors.black),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      currentWeather.city,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${currentWeather.temp.toStringAsFixed(1)}°C',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 30, color: Colors.black),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'H: ${currentWeather.maxTemp.toStringAsFixed(1)}°C, L: ${currentWeather.minTemp.toStringAsFixed(1)}°C',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: forecastWeather.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Forecast(
                                        weatherModel: forecastWeather[index]),
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: Text('No weather data available.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
