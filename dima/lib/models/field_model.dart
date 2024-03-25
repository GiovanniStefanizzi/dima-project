import 'package:cloud_firestore/cloud_firestore.dart';

class Field_model {

  final String name;
  final String cropType;
  
  final DateTime datePlanted;
  
  final bool hailAlert;
  final bool frostAlert;
  final List<GeoPoint> points;

  // todo: memo

  Field_model({required this.name, required this.cropType, required this.datePlanted, required this.hailAlert, required this.frostAlert, required this.points});

  factory Field_model.fromMap(Map<String, dynamic> data) {
    return Field_model(
      name: data['name'],
      cropType: data['cropType'],
      datePlanted: data['datePlanted'],
      hailAlert: data['hailAlert'],
      frostAlert: data['frostAlert'],
      points: data['points'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cropType': cropType,
      'datePlanted': datePlanted,
      'hailAlert': hailAlert,
      'frostAlert': frostAlert,
      'points': points,
    };
  }
}