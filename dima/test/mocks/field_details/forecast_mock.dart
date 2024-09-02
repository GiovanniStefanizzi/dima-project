import 'package:dima/api/open_meteo/open_meteo_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForecastWidgetMock extends StatelessWidget {

  final int weatherCode;
  final double minTemp;
  final double maxTemp;
  final double precipitation;
  final String date;
  
  const ForecastWidgetMock({required this.weatherCode, required this.minTemp, required this.maxTemp, required this.precipitation, required this.date});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool useMobileLayout = screenWidth < 600;

    if(useMobileLayout){
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
                    Image(image:AssetImage('assets/images/${convertCodesToIcons(weatherCode)}.png'), width: screenWidth * 0.1 , height: screenHeight * 0.06),
                    Text('$precipitation mm', style: TextStyle(fontSize: screenHeight *0.0015)),
                  ],
                ),
                Column(
                  children: [
                    Text('$maxTemp °C', style: TextStyle(fontSize: screenHeight *0.002, color: Colors.red)),
                    Text('$minTemp °C', style: TextStyle(fontSize: screenHeight*0.002, color: Colors.blue)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
    else{

      //TABLET LAYOUT


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
            Text(date, style: TextStyle(fontSize: screenHeight *0.0002)),
            SingleChildScrollView(
              child: Row(
                children: [
                  Column(
                    children: [
                      Image(image:AssetImage('assets/images/${convertCodesToIcons(weatherCode)}.png'), width: screenWidth * 0.001 , height: screenHeight * 0.006),
                      Text('$precipitation mm', style: TextStyle(fontSize: screenHeight *0.0015)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('$maxTemp °C', style: TextStyle(fontSize: screenHeight *0.0002, color: Colors.red)),
                      Text('$minTemp °C', style: TextStyle(fontSize: screenHeight*0.0002, color: Colors.blue)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}