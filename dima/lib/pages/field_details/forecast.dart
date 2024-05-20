import 'package:flutter/material.dart';

class ForecastWidget extends StatelessWidget {

  final int weatherCode;
  final double minTemp;
  final double maxTemp;
  final double precipitation;

  const ForecastWidget({required this.weatherCode, required this.minTemp, required this.maxTemp, required this.precipitation});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image(image:AssetImage('assets/images/$weatherCode.png'), width: 80, height: 80),
          Column(
            children: [
              Text('Min: $minTemp °C', style: TextStyle()),
              Text('Max: $maxTemp °C', style: TextStyle()),
              Text('Precipitation: $precipitation mm', style: TextStyle()),
            ],
          ),
        ],
      ),
    );
  }
}