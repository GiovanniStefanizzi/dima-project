import 'package:dima/api/open_meteo/open_meteo_utils.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/pages/field_details/forecast.dart';
import 'package:dima/utils/field_utils.dart';
import 'package:flutter/material.dart';
import 'package:dima/models/meteo_forecast_model.dart';

class MeteoDetailsWidget extends StatefulWidget {
  const MeteoDetailsWidget({super.key});

  @override
  State<MeteoDetailsWidget> createState() => _MeteoDetailsWidgetState();
}


class _MeteoDetailsWidgetState extends State<MeteoDetailsWidget> {


  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, Object>{}) as Map;
    final Field_model field = arguments['field'] as Field_model;

    return FutureBuilder(
      future: Future.wait( [
        getWeatherCode(Field_utils.getCentroid(field.points)),
        getMinTemperature(Field_utils.getCentroid(field.points)),
        getMaxTemperature(Field_utils.getCentroid(field.points)),
        getDailyPrecipitation(Field_utils.getCentroid(field.points)),
        getCurrentHumidity(Field_utils.getCentroid(field.points)),
        getWeatherForecast(Field_utils.getCentroid(field.points)),
      ]),
      builder: (context,AsyncSnapshot<List<Object>> snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }
      else{
        int weatherCode= snapshot.data![0] as int;
        double minTemp= snapshot.data![1] as double;
        double maxTemp= snapshot.data![2] as double;
        double dailyPrecipitation= snapshot.data![3] as double;
        int currentHumidity= snapshot.data![4] as int;
        MeteoForecast_model forecast= snapshot.data![5] as MeteoForecast_model;
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.06,
                        child: Text(
                         '$minTemp°C', style:  TextStyle(fontSize: screenWidth * 0.06,fontWeight: FontWeight.bold, color: Colors.blue)
                       )
                      ),
                      Image(image:AssetImage('assets/images/$weatherCode.png'), width: screenWidth *0.15, height: screenWidth * 0.15),
                      SizedBox(
                      
                        height: screenHeight * 0.06,
                        child: Text(
                          '$maxTemp°C', style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: Colors.red)
                        )
                      )
                    ],
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
                  
                  
                  
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  
                    children: [
                      for (int i = 0; i < 3; i++)
                        ForecastWidget(
                          weatherCode: forecast.weatherCode[i],
                          minTemp: forecast.minTemp[i],
                          maxTemp: forecast.maxTemp[i],
                          precipitation: forecast.precipitation[i],
                          date: forecast.date[i],
                        ),
                    ],
                  ),
                );
              } 
              )

            ],
          )
        );
        }
      }
    );
  }
}