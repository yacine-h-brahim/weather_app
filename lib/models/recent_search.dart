import 'dart:convert';

class RecentSearch {
  final int? id;
  final String? name;
  final double? lat;
  final double? lon;

  RecentSearch({
    this.id,
    this.name,
    this.lat,
    this.lon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lat': lat,
      'lon': lon,
    };
  }

  factory RecentSearch.fromMap(Map<dynamic, dynamic> map) {
    return RecentSearch(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      lat: map['lat'] != null ? map['lat'] as double : null,
      lon: map['lon'] != null ? map['lon'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecentSearch.fromJson(String source) =>
      RecentSearch.fromMap(json.decode(source) as Map<String, dynamic>);
}
