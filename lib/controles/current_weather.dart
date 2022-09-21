import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

import '../API/secret.dart';

class WeatherProvider with ChangeNotifier {
  bool isNight() {
    const int sunset = 19;
    const int sunrise = 6;
    return (DateTime.now().hour < sunrise || DateTime.now().hour > sunset);
  }

  CurrentWeather? currentWeather = CurrentWeather();

  Future<CurrentWeather> getCurrent(String location) async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=$apiKey1';
    try {
      var resoponse = await http.get(Uri.parse(url));
      currentWeather = CurrentWeather.fromJson(jsonDecode(resoponse.body));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
    return currentWeather!;
  }
}
