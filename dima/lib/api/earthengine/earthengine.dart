import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';


Future<String> getNDVI(List<GeoPoint> points) async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/ndvi?points='+jsonEncode(points)));

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