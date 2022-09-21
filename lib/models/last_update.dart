// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LastUpdate {
  final int? id;
  final String lastUpdateTime;
  const LastUpdate({
    this.id,
    required this.lastUpdateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lastUpdateTime': lastUpdateTime,
    };
  }

  factory LastUpdate.fromMap(Map<String, dynamic> map) {
    return LastUpdate(
      id: map['id'] != null ? map['id'] as int : null,
      lastUpdateTime: map['lastUpdateTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LastUpdate.fromJson(String source) =>
      LastUpdate.fromMap(json.decode(source) as Map<String, dynamic>);
}
