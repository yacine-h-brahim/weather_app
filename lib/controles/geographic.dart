import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/API/secret.dart';
import 'package:weather_app/models/geo.dart';

class Geographic {
  static List<Goe> goes = [];

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

    try {
      http.Response response = await http.get(Uri.parse(
          'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$apiKey1'));
      code = response.statusCode;
      goes = [];
      for (var element in jsonDecode(response.body)) {
        goes.add(Goe.fromJson(element));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }

    return code;
  }
}
