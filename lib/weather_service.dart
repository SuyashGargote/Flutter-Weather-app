import 'dart:convert';
import 'package:http/http.dart' as http;
import 'const.dart';


class WeatherService {
  static const String apiKey =apikeys;

  static const String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await http.get(Uri.parse("$baseUrl?q=$city&appid=$apiKey&units=metric"));
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
