import 'dart:convert';

class RecentSearch {
  final int? id;
  late final String? name;
  final dynamic lat;
  final dynamic lon;
  final String? country;

  RecentSearch({
    this.id,
    this.name,
    this.country,
    this.lat,
    this.lon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'county': country,
      'lat': lat,
      'lon': lon,
    };
  }

  factory RecentSearch.fromMap(Map<dynamic, dynamic> map) {
    return RecentSearch(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      lat: map['lat'] != null ? map['lat'] as double : null,
      lon: map['lon'] != null ? map['lon'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecentSearch.fromJson(String source) =>
      RecentSearch.fromMap(json.decode(source) as Map<String, dynamic>);
}
