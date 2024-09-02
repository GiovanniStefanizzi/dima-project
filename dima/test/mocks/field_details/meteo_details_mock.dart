import 'package:dima/api/open_meteo/open_meteo_utils.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/pages/field_details/forecast.dart';
import 'package:dima/utils/field_utils.dart';
import 'package:flutter/material.dart';
import 'package:dima/models/meteo_forecast_model.dart';

import 'forecast_mock.dart';

class MeteoDetailsWidgetMock extends StatefulWidget {
  const MeteoDetailsWidgetMock({super.key});

  @override
  State<MeteoDetailsWidgetMock> createState() => _MeteoDetailsWidgetState();
}


class _MeteoDetailsWidgetState extends State<MeteoDetailsWidgetMock> {


  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool useMobileLayout = screenWidth < 600;

    //final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, Object>{}) as Map;
    //final Field_model field = arguments['field'] as Field_model;

    if (useMobileLayout) {
          int weatherCode= 3;
          double minTemp= 12.1;
          double maxTemp= 30.2;
          double dailyPrecipitation= 1.0;
          int currentHumidity= 40;
          MeteoForecast_model forecast= MeteoForecast_model(
            weatherCode: [1,2,3],
            minTemp: [10.0, 20.0, 30.0],
            maxTemp: [20.0, 30.0, 40.0],
            precipitation: [1.0, 2.0, 3.0],
            date: ['2021-10-10', '2021-10-11', '2021-10-12']
          );
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(screenHeight * 0.02),
                  margin: EdgeInsets.all(screenHeight * 0.0175),
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
                  
                  Container(
                    // margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.06,
                            child: Text(
                            '$minTemp°C', style:  TextStyle(fontSize: screenWidth * 0.006,fontWeight: FontWeight.bold, color: Colors.blue)
                          )
                          ),
                          Image(image:AssetImage('assets/images/$weatherCode.png'), width: screenWidth *0.015, height: screenWidth * 0.015),
                          SizedBox(
                          
                            height: screenHeight * 0.06,
                            child: Text(
                              '$maxTemp°C', style: TextStyle(fontSize: screenWidth * 0.006, fontWeight: FontWeight.bold, color: Colors.red)
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                  
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // margin: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Image(image: const AssetImage('assets/images/precipitations.png'), width: screenHeight * 0.05, height:screenHeight * 0.05),
                              Text('${dailyPrecipitation}mm', style: TextStyle(fontSize: screenHeight * 0.03)),                   
                            ],
                          ),
                          ),
                        Container(
                          // margin: const EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Text('$currentHumidity%', style: TextStyle(fontSize: screenHeight * 0.03, color: Colors.orange)),
                              Image(image: AssetImage('assets/images/humidity.png'), width: screenHeight * 0.05, height:screenHeight * 0.05),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                    ],
                    ),
                ),
                Builder(builder: (context) {
                  return Container(
                    
                    
                    
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      
                        children: [
                          for (int i = 0; i < 3; i++)
                            SizedBox(
                              width: screenWidth * 0.3,
                              child: ForecastWidgetMock(
                                weatherCode: forecast.weatherCode[i],
                                minTemp: forecast.minTemp[i],
                                maxTemp: forecast.maxTemp[i],
                                precipitation: forecast.precipitation[i],
                                date: forecast.date[i],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                } 
                )

              ],
            )
          );
          }
    else{


      //  TABLET LAYOUT


          int weatherCode= 3;
          double minTemp= 12.1;
          double maxTemp= 30.2;
          double dailyPrecipitation= 1.0;
          int currentHumidity= 40;
          MeteoForecast_model forecast= MeteoForecast_model(
            weatherCode: [1,2,3],
            minTemp: [10.0, 20.0, 30.0],
            maxTemp: [20.0, 30.0, 40.0],
            precipitation: [1.0, 2.0, 3.0],
            date: ['2021-10-10', '2021-10-11', '2021-10-12']
          );
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: screenHeight * 0.5,
                  padding: EdgeInsets.all(screenHeight * 0.025),
                  margin: EdgeInsets.all(screenHeight * 0.02),
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
                  
                  Container(
                    // margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      
                      children: [
                        SizedBox(
                          height: screenHeight * 0.13,
                          child: Text(
                          '$minTemp°C', style:  TextStyle(fontSize: screenWidth * 0.0004,fontWeight: FontWeight.bold, color: Colors.blue)
                        )
                        ),
                        
                        
                        SizedBox(
                        
                          height: screenHeight * 0.13,
                          child: Text(
                            '$maxTemp°C', style: TextStyle(fontSize: screenWidth * 0.004, fontWeight: FontWeight.bold, color: Colors.red)
                          )
                        )
                      ],
                    ),
                  ),
                  Image(image:AssetImage('assets/images/$weatherCode.png'), width: screenWidth *0.0012, height: screenWidth * 0.0011),
                  SizedBox(height: screenHeight * 0.07),
                  Container(
                  
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          // margin: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Image(image: const AssetImage('assets/images/precipitations.png'), width: screenHeight * 0.0005, height:screenHeight * 0.0005),
                              Text('${dailyPrecipitation}mm', style: TextStyle(fontSize: screenHeight * 0.0038)),                   
                            ],
                          ),
                          ),
                        Container(
                          // margin: const EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Text('$currentHumidity%', style: TextStyle(fontSize: screenHeight * 0.0038, color: Colors.orange)),
                              Image(image: AssetImage('assets/images/humidity.png'), width: screenHeight * 0.005, height:screenHeight * 0.005),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                    ],
                    ),
                ),
                Builder(builder: (context) {
                  return Container(
                    child: SizedBox(
                      
                      child: Row(
                                            
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      
                        children: [
                          for (int i = 0; i < 3; i++)
                            SizedBox(
                              width: screenWidth * 0.1,
                              child: ForecastWidgetMock(
                                weatherCode: forecast.weatherCode[i],
                                minTemp: forecast.minTemp[i],
                                maxTemp: forecast.maxTemp[i],
                                precipitation: forecast.precipitation[i],
                                date: forecast.date[i],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                } 
                )

              ],
            )
          );
          
        }
      
    }
  }
