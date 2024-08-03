import 'package:dima/api/open_meteo/open_meteo_utils.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/pages/field_details/forecast.dart';
import 'package:dima/utils/field_utils.dart';
import 'package:flutter/material.dart';
import 'package:dima/models/meteo_forecast_model.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class MeteoDetailsWidget extends StatefulWidget {
  const MeteoDetailsWidget({super.key});

  @override
  State<MeteoDetailsWidget> createState() => _MeteoDetailsWidgetState();
}


class _MeteoDetailsWidgetState extends State<MeteoDetailsWidget> {


  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, Object>{}) as Map;
    final Field_model field = arguments['field'] as Field_model;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 237, 235, 235)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                
              //mainAxisAlignment: MainAxisAlignment.center,
              child: 
                FutureBuilder(
                  future: getWeatherCode(Field_utils.getCentroid(field.points)),
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: 15,
                        height: 15,
                        //child: CircularProgressIndicator( strokeWidth: 2,)
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Image(image:AssetImage('assets/images/${snapshot.data}.png'), width: 80, height: 80);
                    }
                  },
              ),
            ),
            Container(
              // margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                    future: getMinTemperature(Field_utils.getCentroid(field.points)),
                    builder: (context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator( strokeWidth: 2,)
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Container(
                          
                          height: 45,
                          child: Text(
                            '${snapshot.data}°C', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue)
                          )
                        );
                      }
                    },
                  ),
                  FutureBuilder(
                    future: getMaxTemperature(Field_utils.getCentroid(field.points)),
                    builder: (context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator( strokeWidth: 2,)
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Container(
                        
                          height: 45,
                          child: Text(
                            '${snapshot.data}°C', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red)
                          )
                        );
                      }
                    },
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
                        Image(image: AssetImage('assets/images/precipitations.png'), width: 30, height: 30),
                        FutureBuilder(
                          future: getDailyPrecipitation(Field_utils.getCentroid(field.points)),
                          builder: (context, AsyncSnapshot<double> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator( strokeWidth: 2,)
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Container(
                                width: 100,
                                height: 35,
                                child: Text(
                                  '${snapshot.data}mm', style: TextStyle(fontSize: 25)
                                )
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    ),
                  Container(
                    // margin: const EdgeInsets.only(right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
  
                        FutureBuilder(
                          future: getCurrentHumidity(Field_utils.getCentroid(field.points)),
                          builder: (context, AsyncSnapshot<int> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator( strokeWidth: 2,)
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Container(
                                width: 55,
                                height: 35,
                                child: Text(
                                  '${snapshot.data}%', style: TextStyle(fontSize: 25, color: Colors.orange)
                                )
                              );
                            }
                          },
                        ),
                        Image(image: AssetImage('assets/images/humidity.png'), width: 30, height: 30),
                      ],
                    )
                  )
                ],
              ),
            ),
              ],
              ),
          ),
          FutureBuilder(
            future: getWeatherForecast(Field_utils.getCentroid(field.points)), 
            builder: (context, AsyncSnapshot<MeteoForecast_model> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator( strokeWidth: 2,)
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Builder(builder: (context) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    
                    children: [
                      for (int i = 0; i < 3; i++)
                        ForecastWidget(
                          weatherCode: snapshot.data!.weatherCode[i],
                          minTemp: snapshot.data!.minTemp[i],
                          maxTemp: snapshot.data!.maxTemp[i],
                          precipitation: snapshot.data!.precipitation[i],
                          date: snapshot.data!.date[i],
                        ),
                    ],
                  );
                } 
                );
              }
            },
            )
          
        ],
      )
    );
  }
}