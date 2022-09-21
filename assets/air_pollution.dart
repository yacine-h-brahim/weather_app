class AirPollutionData {
  Coord? coord;
  List<Lst>? lst;

  AirPollutionData({this.coord, this.lst});

  AirPollutionData.fromJson(Map<String, dynamic> json) {
    coord = json['coord'] != null ? Coord.fromJson(json['coord']) : null;
    if (json['list'] != null) {
      lst = <Lst>[];
      json['list'].forEach((v) {
        lst!.add(Lst.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coord != null) {
      data['coord'] = coord!.toJson();
    }
    if (lst != null) {
      data['list'] = lst!.map((v) => v.toJson()).toList();
    }
    return data;
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
  Mn? mn;
  Components? components;
  int? dt;

  Lst({this.mn, this.components, this.dt});

  Lst.fromJson(Map<String, dynamic> json) {
    mn = json['main'] != null ? Mn.fromJson(json['main']) : null;
    components = json['components'] != null
        ? Components.fromJson(json['components'])
        : null;
    dt = json['dt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mn != null) {
      data['main'] = mn!.toJson();
    }
    if (components != null) {
      data['components'] = components!.toJson();
    }
    data['dt'] = dt;
    return data;
  }
}

class Mn {
  double? aqi;

  Mn({this.aqi});

  Mn.fromJson(Map<String, dynamic> json) {
    aqi = json['aqi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aqi'] = aqi;
    return data;
  }
}

class Components {
  double? co;
  double? no;
  double? no2;
  double? o3;
  double? so2;
  double? pm25;
  double? pm10;
  double? nh3;

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
