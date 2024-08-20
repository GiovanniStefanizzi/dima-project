import 'package:dima/api/open_meteo/open_meteo_utils.dart';
import 'package:flutter/material.dart';

class ForecastWidget extends StatelessWidget {

  final int weatherCode;
  final double minTemp;
  final double maxTemp;
  final double precipitation;
  final String date;
  
  const ForecastWidget({required this.weatherCode, required this.minTemp, required this.maxTemp, required this.precipitation, required this.date});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.all(screenHeight * 0.005),
      padding: EdgeInsets.all(screenHeight * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromARGB(255, 237, 235, 235)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],

      ),
      child: Column(
        children: [
          Text(date, style: TextStyle(fontSize: screenHeight *0.015)),
          Row(
            children: [
              Column(
                children: [
                  Image(image:AssetImage('assets/images/${convertCodesToIcons(weatherCode)}.png'), width: screenHeight * 0.06, height: screenHeight * 0.06),
                  Text('$precipitation mm', style: TextStyle(fontSize: screenHeight *0.015)),
                ],
              ),
              Column(
                children: [
                  Text('$minTemp °C', style: TextStyle(fontSize: screenHeight*0.02, color: Colors.blue)),
                  Text('$maxTemp °C', style: TextStyle(fontSize: screenHeight *0.02, color: Colors.red)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}