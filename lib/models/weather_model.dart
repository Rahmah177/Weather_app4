class WeatherModel {
  final String city;
  final double temp;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String iconCode;
  final String date;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.iconCode,
    required this.date,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    String dateString = json['dt_txt'] ?? '';
    DateTime dateTime;

    try {
      dateTime = DateTime.parse(dateString);
    } catch (e) {

      dateTime = DateTime.now();
      print('Error parsing date: $e');
    }

    return WeatherModel(
      city: json['name'] ?? '',
      temp: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
      minTemp: (json['main']['temp_min'] as num).toDouble(),
      iconCode: json['weather'][0]['icon'] ?? '',
      date: dateTime.toIso8601String(),
    );
  }

}
