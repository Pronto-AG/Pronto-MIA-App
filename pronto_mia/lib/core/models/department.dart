import 'package:flutter/foundation.dart';

class Department {
  final int id;
  final String name;

  Department({this.id, this.name});

  Department.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String;
}