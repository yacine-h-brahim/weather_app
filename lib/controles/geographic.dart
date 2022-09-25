import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/API/secret.dart';

class Geographic {
  getLoction(String location) async {
    try {
      String url =
          'http://api.openweathermap.org/geo/1.0/direct?q=$location&limit=5&appid=$apiKey1';
      http.Response response = await http.get(Uri.parse(url));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }
}
