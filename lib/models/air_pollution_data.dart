import 'package:flutter/material.dart';

class AirPollutionData {
  Coord? coord;
  List<Lst>? list;
  String? mark;

  AirPollutionData({this.coord, this.list, this.mark});
  AirPollutionData.fromJson(Map<String, dynamic> json) {
    coord = json['coord'] != null ? Coord.fromJson(json['coord']) : null;
    if (json['list'] != null) {
      list = [];
      list = [
        Lst(
            components: Components(
              co: json['list'][0]['components']['co'],
              nh3: json['list'][0]['components']['nh3'],
              no2: json['list'][0]['components']['no2'],
              no: json['list'][0]['components']['no'],
              o3: json['list'][0]['components']['o3'],
              pm25: json['list'][0]['components']['pm25'],
              pm10: json['list'][0]['components']['pm10'],
              so2: json['list'][0]['components']['so2'],
            ),
            dt: json['list'][0]['dt'],
            main: Main(aqi: json['list'][0]['main']['aqi']))
      ];

      // json['list'].forEach((v) {
      //   list!.add(Lst.fromJson(v));
      // });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coord != null) {
      data['coord'] = coord!.toJson();
    }
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Map<String?, dynamic> getMarks(dynamic aqi) {
    Map<String, dynamic> map = {
      'name': '',
      'color': Colors.red,
      'perc': 0.2,
      'description': ''
    };
    if (aqi != null) {
      //TODO: CHANGE DESCRIPTOINS AND NAMES ON THIS MAP;
      switch (aqi) {
        case 1:
          map['name'] = 'Good';
          map['color'] = Colors.green;
          map['perc'] = 0.2;
          map['description'] =
              'Everyone can continue their outdoor activities normally.';
          break;
        case 2:
          map['name'] = 'Fair';
          map['color'] = Colors.orange;
          map['perc'] = 0.4;
          map['description'] =
              'Only very few hypersensitive people should reduce outdoor activities.';
          break;
        case 3:
          map['name'] = 'Moderate';
          map['color'] = Colors.yellow;
          map['perc'] = 0.6;
          map['description'] =
              'Children, seniors and individuals with respiratory or heart diseases should reduce sustained and high-intensity outdoor exercises.';
          break;
        case 4:
          map['name'] = 'Poor';
          map['color'] = Colors.red;
          map['perc'] = 0.8;
          map['description'] =
              'Children, seniors and individuals with heart or lung diseases should stay indoors and avoid outdoor activities. General population should reduce outdoor activities.';
          break;
        case 5:
          map['name'] = 'Very Poor';
          map['color'] = Colors.brown;
          map['perc'] = 1.0;
          map['description'] =
              'Children, seniors and the sick should stay indoors and avoid physical exertion. General population should avoid outdoor activities.';
          break;
      }
    }
    return map;
  }
}

class Coord {
  double? lon;
  double? lat;

  Coord({this.lon, this.lat});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lon'] = lon;
    data['lat'] = lat;
    return data;
  }
}

class Lst {
  Main? main;
  Components? components;
  dynamic dt;

  Lst({this.main, this.components, this.dt});

  Lst.fromJson(Map<String, dynamic> json) {
    main = json['main'] != null ? Main.fromJson(json['main']) : null;
    components = json['components'] != null
        ? Components.fromJson(json['components'])
        : null;
    dt = json['dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (main != null) {
      data['main'] = main!.toJson();
    }
    if (components != null) {
      data['components'] = components!.toJson();
    }
    data['dt'] = dt;
    return data;
  }
}

class Main {
  dynamic aqi;

  Main({this.aqi});

  Main.fromJson(Map<String, dynamic> json) {
    aqi = json['aqi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aqi'] = aqi;
    return data;
  }
}

class Components {
  dynamic co;
  dynamic no;
  dynamic no2;
  dynamic o3;
  dynamic so2;
  dynamic pm25;
  dynamic pm10;
  dynamic nh3;

  Components(
      {this.co,
      this.no,
      this.no2,
      this.o3,
      this.so2,
      this.pm25,
      this.pm10,
      this.nh3});

  Components.fromJson(Map<String, dynamic> json) {
    co = json['co'];
    no = json['no'];
    no2 = json['no2'];
    o3 = json['o3'];
    so2 = json['so2'];
    pm25 = json['pm2_5'];
    pm10 = json['pm10'];
    nh3 = json['nh3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['co'] = co;
    data['no'] = no;
    data['no2'] = no2;
    data['o3'] = o3;
    data['so2'] = so2;
    data['pm2_5'] = pm25;
    data['pm10'] = pm10;
    data['nh3'] = nh3;
    return data;
  }
}
