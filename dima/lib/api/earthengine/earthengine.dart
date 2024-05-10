import 'dart:convert';
import 'package:dima/utils/field_utils.dart';
import 'package:dima/utils/map_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getMap(List<GeoPoint> points, MapOverlayType mapType) async {
  String mapTypeString = mapType.name.toString();
  String polygonString = Field_utils.encodeGeoPoints(points);
  try {

    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/${mapTypeString}?points=$polygonString'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String imageUrl = data['link'];

      print("Image URL: $imageUrl");
      return imageUrl;
    } else {
      return ('Failed to load image');
    }
  } catch (e) {
    return ('Failed to connect to server');
  }
}