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
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 237, 235, 235)),
        borderRadius: BorderRadius.circular(10),

      ),
      child: Column(
        children: [
          Text(date, style: TextStyle(fontSize: 15)),
          Row(
            children: [
              Column(
                children: [
                  Image(image:AssetImage('assets/images/${convertCodesToIcons(weatherCode)}.png'), width: 65, height: 65),
                  Text('$precipitation mm', style: TextStyle()),
                ],
              ),
              Column(
                children: [
                  Text('$minTemp °C', style: TextStyle()),
                  Text('$maxTemp °C', style: TextStyle()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}