import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/models/user_model.dart';
import 'package:dima/api/open_meteo/open_meteo_utils.dart';
import 'package:dima/utils/field_utils.dart';
import 'package:flutter/material.dart';

class FieldListScreen extends StatefulWidget {
  const FieldListScreen({super.key});

  @override
  State<FieldListScreen> createState() => _MyWidgetState();
}


Future<List<Field_model>> getFields() async {
  User_model? user = await Firestore().getCurrentUser();

  // Check if the user is not null
  if (user != null) {
    // If user is not null, return the fields from the user
    print(user.toString());
    return user.getFields();
  } else {
    // If user is null, return an empty list or handle the case accordingly
    return []; // You can return an empty list or throw an error, etc.
  }
}





class _MyWidgetState extends State<FieldListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddFieldScreen
          Navigator.pushNamed(context, '/add_field');
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Fields'),
      ),
      body: FutureBuilder<List<Field_model>>(
        future: getFields(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the future to complete
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if the future encounters an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Build the ListView using the data returned by the future
            List<Field_model>? fields = snapshot.data;
            if (fields != null && fields.isNotEmpty) {
              return ListView.builder(
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  // Build each item of the ListView using the Field_model
                  Field_model field = fields[index];
                  return ListTile(
                    leading: Icon(Icons.map),
                    title: Text(field.name),
                    subtitle: Text(field.cropType) ,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      
                      children: [
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
                            return Image(image:AssetImage('assets/images/${snapshot.data}.png'), width: 50, height: 50);
                          }
                        },
                      ),
                      FutureBuilder(
                      future: getTemperature(Field_utils.getCentroid(field.points)),
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
                            width: 45,
                            height: 25,
                            child: Text(
                              '${snapshot.data}°C', style: TextStyle(fontSize: 15)
                            )
                          );
                        }
                      },
                    ),
                      ],
                      
                    ),
                    onTap: () {
                      // Navigate to the FieldDetailsScreen
                      Navigator.pushNamed(
                        context, '/field_details',
                        arguments:{
                        'field': field,
                        'index': index}
                      );
                    },
                  );
                },
              );
            } else {
              // Show a message when there are no fields
              return Center(child: Text('No fields available'));
            }
          }
        },
      ),
    );
  }
}