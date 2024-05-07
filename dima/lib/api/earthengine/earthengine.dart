import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

Future<String> getNDVI(String apiUrl) async {
  try {
    final response = await http.get(Uri.parse(apiUrl));

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