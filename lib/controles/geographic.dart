import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/API/secret.dart';
import 'package:weather_app/models/geo.dart';
import 'package:weather_app/models/recent_search.dart';

class Geographic {
  static RecentSearch recent = RecentSearch();

  static Future<List<Goe>> getLoction(String query) async {
    List<Goe> list = [];

    try {
      String url =
          'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$apiKey1';
      http.Response response = await http.get(Uri.parse(url));
      for (var element in jsonDecode(response.body)) {
        list.add(Goe.fromJson(element));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
    return list;
  }

  static Future<int> codeStatus(String query) async {
    int code = 0;
    Goe goe = Goe();
    try {
      http.Response response = await http.get(Uri.parse(
          'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=1&appid=$apiKey1'));
      code = response.statusCode;

      goe = Goe.fromJson(jsonDecode(response.body).first);
      recent = RecentSearch(
          name: goe.name, country: goe.country, lat: goe.lat, lon: goe.lon);
      print(recent.toMap().toString());
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
    return code;
  }
}
