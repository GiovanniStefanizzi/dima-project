import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:dima/models/meteo_forecast_model.dart';

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
    //print('RESPONSE:'+code.toString()+" CONVERSIOED:"+convertCodesToIcons(code).toString());
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
    //print('RESPONSE:'+temp.toString());
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
    //print('RESPONSE:'+temp.toString());
    return temp;
  } else {
    throw HttpException('Failed to load temperature');
  }
}

Future<double> getDailyPrecipitation(GeoPoint point) async{
  var lon = point.longitude;
  var lat = point.latitude;
  var response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=precipitation_sum&timezone=Europe%2FBerlin&forecast_days=1'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    double precipitation = data['daily']['precipitation_sum'][0];
    //print('RESPONSE:'+precipitation.toString());
    return precipitation;
  } else {
    throw HttpException('Failed to load precipitation');
  } 
}

Future<int> getCurrentHumidity(GeoPoint point) async {
  var lon = point.longitude;
  var lat = point.latitude;
  var response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=relative_humidity_2m&timezone=Europe%2FBerlin&forecast_days=1'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    int humidity = data['current']['relative_humidity_2m'];
    //print('RESPONSE:'+humidity.toString());
    return humidity;
  } else {
    throw HttpException('Failed to load humidity');
  }
} 

Future<MeteoForecast_model> getWeatherForecast(GeoPoint point) async {
  var lon = point.longitude;
  var lat = point.latitude;
  var response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum&timezone=Europe%2FBerlin'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
     List<double> minTemp = (data['daily']['temperature_2m_min'] as List)
      .map((item) => item as double)
      .toList()
      .sublist(1,4);
    List<double> maxTemp = (data['daily']['temperature_2m_max'] as List)
    .map((item) => item as double)
    .toList()
    .sublist(1,4);
    List<double> precipitation = (data['daily']['precipitation_sum'] as List)
    .map((item) => item as double)
    .toList()
    .sublist(1,4);
    List<int> weatherCode = (data['daily']['weather_code'] as List)
    .map((item) => item as int)
    .toList()
    .sublist(1,4);
    List<String> date = (data['daily']['time'] as List)
    .map((item) => (item as String).substring(5,10))
    .toList()
    .sublist(1,4);

    print("WEATHER CODES: "+weatherCode.toString());
    print("MIN TEMP: "+minTemp.toString());
    print("MAX TEMP: "+maxTemp.toString());
    print("PRECIPITATION: "+precipitation.toString());
    print("DATE: "+date.toString());
    return MeteoForecast_model(weatherCode: weatherCode, minTemp: minTemp, maxTemp: maxTemp, precipitation: precipitation, date: date);
  } else {
    throw HttpException('Failed to load meteo forecast');
  }

}