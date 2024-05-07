import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/models/user_model.dart';

class Field_model {

  final String name;
  final String cropType;
  
  final String datePlanted;
  
  final bool hailAlert;
  final bool frostAlert;
  final List<GeoPoint> points;

  // todo: memo

  Field_model({required this.name, required this.cropType, required this.datePlanted, required this.hailAlert, required this.frostAlert, required this.points});

  // factory Field_model.fromMap(Map<String, dynamic> data) {
  //   return Field_model(
  //     name: data['name'],
  //     cropType: data['cropType'],
  //     datePlanted: data['datePlanted'],
  //     hailAlert: data['hailAlert'],
  //     frostAlert: data['frostAlert'],
  //     points: data['points'],
  //   );
  // }

  factory Field_model.fromMap(Map<String, dynamic> data) {
    List<dynamic> pointsData = data['points'];
    List<GeoPoint> geoPoints = pointsData.map((point) {
      double latitude = point.latitude;
      double longitude = point.longitude;
      return GeoPoint(latitude, longitude);
    }).toList();

    return Field_model(
      name: data['name'],
      cropType: data['cropType'],
      datePlanted: data['datePlanted'],
      hailAlert: data['hailAlert'],
      frostAlert: data['frostAlert'],
      points: geoPoints,
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