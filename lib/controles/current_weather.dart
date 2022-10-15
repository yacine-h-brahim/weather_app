import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/recent_search.dart';
import 'package:weather_app/models/weather.dart';

import '../API/secret.dart';

class WeatherProvider extends ChangeNotifier {
  ///////THEME PROVIDER ///////////////////////////

  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleThemeMode(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /////////////////////WEATHER PROVIDER ////////////////////////
  String? lastUpdateTime = '';
  RecentSearch? recentSearch = RecentSearch();
  List<RecentSearch> recentSearchList = [];

  bool isNight() {
    const int sunset = 19;
    const int sunrise = 6;
    return (DateTime.now().hour < sunrise || DateTime.now().hour > sunset);
  }

  static CurrentWeather currentWeather = CurrentWeather();

  Future<CurrentWeather> getCurrent() async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=${recentSearch!.name}&units=metric&appid=$apiKey1';
    try {
      var resoponse = await http.get(Uri.parse(url));

      currentWeather = CurrentWeather.fromJson(jsonDecode(resoponse.body));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
    return currentWeather;
  }
}
