import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/API/secret.dart';
import 'package:weather_app/models/forecast.dart';
import 'package:http/http.dart' as http;

class ForecastFiveThreeProvider {
  static Future<ForecastFiveThree?> getForcast(double? lat, double? lon) async {
    String url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey2&units=metric';

    ForecastFiveThree forecastFiveThree = ForecastFiveThree();
    try {
      http.Response response = await http.get(Uri.parse(url));
      forecastFiveThree = ForecastFiveThree.fromJson(jsonDecode(response.body));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }

    return forecastFiveThree;
  }

  static List dailyListTemp(List<Lst> lst) {
    Map map = {};
    for (var element in lst) {
      map[DateFormat('M/d/y').format(DateTime.parse(element.dtTxt!))] = element;
    }
    return map.values.toList();
  }
}
