import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

Future<double> getTemperature(GeoPoint point) async {
  var lon = point.longitude;
  var lat = point.latitude;
  var response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m&timezone=Europe%2FBerlin'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    double temp = data['current']['temperature_2m'];
    //print('RESPONSE:'+temp.toString());
    return temp;
  } else {
    throw HttpException('Failed to load temperature');
  }
}

Future<int> getWeatherCode(GeoPoint point) async {
  var lon = point.longitude;
  var lat = point.latitude;
  var response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=weathercode&timezone=Europe%2FBerlin'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    int code = data['current']['weathercode'];
    print('RESPONSE:'+code.toString()+" CONVERSIOED:"+convertCodesToIcons(code).toString());
    return convertCodesToIcons(code);
  } else {
    throw HttpException('Failed to load weather code');
  }
}

int convertCodesToIcons(int weatherCode){
  switch (weatherCode) {
    case 0: return 1;                                  // Clear sky
    case (1 || 2 || 3): return 2;                      // Few clouds
    case (45 || 48): return 3;                         // Fog
    case (51 || 53 || 55): return 4;                   // Drizzle
    case (56 || 57): return 5;                         // Freezing Rain
    case (61 || 63 || 65): return 6;                   // Rain
    case (71 || 73 || 75 || 77 || 85 || 86): return 7; // Snow
    case (80 || 81 || 82): return 8;                   // Rain showers
    case (95 || 96 || 99): return 9;                   // Thunderstorm
    default: return 0;                                 // Unknown
  }
}

Future<double> getMaxTemperature(GeoPoint point) async {
  var lon = point.longitude;
  var lat = point.latitude;
  var response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max&timezone=Europe%2FBerlin&forecast_days=1'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    double temp = data['daily']['temperature_2m_max'][0];
    print('RESPONSE:'+temp.toString());
    return temp;
  } else {
    throw HttpException('Failed to load temperature');
  }
}

Future<double> getMinTemperature(GeoPoint point) async {
  var lon = point.longitude;
  var lat = point.latitude;
  var response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_min&timezone=Europe%2FBerlin&forecast_days=1'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    double temp = data['daily']['temperature_2m_min'][0];
    print('RESPONSE:'+temp.toString());
    return temp;
  } else {
    throw HttpException('Failed to load temperature');
  }
}