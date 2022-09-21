import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/API/secret.dart';
import 'package:weather_app/models/air_pollution_data.dart';

class AirQulity {
  AirPollutionData? airPollutionData = AirPollutionData();

  Future<AirPollutionData?> getAirQulity(double lon, lat) async {
    try {
      String url =
          'http://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey2';
      var response = await http.get(Uri.parse(url));
      airPollutionData = AirPollutionData.fromJson(jsonDecode(response.body));
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 4);
    }
    return airPollutionData;
  }
}
