import 'package:flutter/material.dart';
import 'weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  String city = "London";
  Map<String, dynamic>? weatherData;
  bool isLoading = false;

  void fetchWeather() async {
    setState(() => isLoading = true);
    
    try {
      final data = await _weatherService.getWeather(city);
      setState(() => weatherData = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
    
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Enter City",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => city = value,
              onSubmitted: (value) => fetchWeather(),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : weatherData != null
                    ? Column(
                        children: [
                          Text(
                            "${weatherData!['name']}, ${weatherData!['sys']['country']}",
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${weatherData!['main']['temp']}°C",
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(weatherData!['weather'][0]['description']),
                        ],
                      )
                    : const Text("Enter a city to get weather"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchWeather,
              child: const Text("Get Weather"),
            ),
          ],
        ),
      ),
    );
  }
}
