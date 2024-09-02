import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/models/user_model.dart';
import 'package:dima/api/open_meteo/open_meteo_utils.dart';
import 'package:dima/utils/background_utils.dart';
import 'package:dima/utils/field_utils.dart';
import 'package:flutter/material.dart';

import '../field_details/field_details_screen_mock.dart';

class FieldListScreenMock extends StatefulWidget {
  const FieldListScreenMock({super.key});

  @override
  State<FieldListScreenMock> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FieldListScreenMock> {
  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenSize = MediaQuery.of(context).size;


    List<GeoPoint> geoPoints = [GeoPoint(45.478, 9.230), GeoPoint(45.475, 9.230), GeoPoint(45.478, 9.235)];
    Field_model field_model = Field_model(name: 'name', cropType: 'cropType', datePlanted: '2024-08-14', hailAlert: false, frostAlert: false, points: geoPoints, activities: []);
    List<Field_model> fields = [field_model];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 153, 194, 162),
        onPressed: () {
          // Navigate to the AddFieldScreen
          //Navigator.pushNamed(context, '/add_field');
          //NotificationService().showNotification(title: 'Sample title', body: 'It works!', payLoad: 'payload');
          //initializeBackgroundFetch();
          
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Fields'),
      ),
      body:   ListView.builder(
                
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  // Build each item of the ListView using the Field_model
                  Field_model field = fields[index];
                  return SizedBox(
                    width: screenWidth,
                    child: ListTile(
                      title: Text(field.name),
                      subtitle: Text(field.cropType) ,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        
                        children: [
                        Image(key:Key("image"),image: AssetImage('assets/images/2.png'), width: screenWidth*0.15),
                        Container(
                              alignment: Alignment.center,
                              width: screenWidth*0.1,
                              height: screenHeight*0.1,
                              //margin: EdgeInsets.only(top: screenHeight*0.015),
                              child: Text(
                                key: Key('temperature'),
                                '10°C',
                                //style: TextStyle(fontSize: screenWidth>screenHeight?screenHeight*0.02:screenWidth*0.02)
                              )
                            ),
                        ],
                        
                      ),
                      onTap: () {
                        // Navigate to the FieldDetailsScreen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FieldDetailsScreenMock()));
                      },
                    ),
                  );
                },
              ));
            }
        
      
    
  }
  
  Future <List<Field_model>> getFields() async {
    //make a list of geopoints
    List<GeoPoint> geoPoints = [GeoPoint(45.478, 9.230), GeoPoint(45.475, 9.230), GeoPoint(45.478, 9.235)];
    Field_model field_model = Field_model(name: 'name', cropType: 'cropType', datePlanted: '2024-08-14', hailAlert: false, frostAlert: false, points: geoPoints, activities: []);
    List<Field_model> fields = [field_model];
    return fields;
  }
  
  getFrostAlert(Field_model field) {
    return false;
  }

  getHailAlert(Field_model field) {
    return false;
  }
