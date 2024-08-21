import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/activity_model.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/models/user_model.dart';
import 'package:dima/pages/field_list/field_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


Future<List<Activity>> getActivities(fieldIndex) async {
  User_model? user = await Firestore().getCurrentUser();
  Field_model? field = user?.fields[fieldIndex];
  // Check if the user is not null
  if (user != null) {
    // If user is not null, return the fields from the user
    return field!.getActivities();
  } else {
    // If user is null, return an empty list or handle the case accordingly
    return []; // You can return an empty list or throw an error, etc.
  }
}

class ActivityWidget extends StatefulWidget {
  @override
  _activityWidgetState createState() => _activityWidgetState();
}

class _activityWidgetState extends State<ActivityWidget> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, Object>{}) as Map;
    final int fieldIndex = arguments['index'] as int;
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder(
        future: getActivities(fieldIndex),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || _isEditing) {
            // Show a loading indicator while waiting for the future to complete
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ) {
            // Show an error message if the future encounters an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Activity>? activities = snapshot.data;
            if (activities != null && activities.isNotEmpty) {
              return ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index){
                  Activity activity = activities[index];
                  return ListTile(
                    title: Text(activity.name, style: TextStyle(fontSize: screenHeight*0.025)),
                    subtitle: Text(activity.description, style: TextStyle(fontSize: screenHeight*0.02)),
                    trailing: Wrap(
                      children: [
                        Text(activity.date.substring(0,10), style: TextStyle(fontSize: screenHeight*0.015, color: Colors.grey)),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: const Color.fromARGB(255, 153, 194, 162),
                                  title: Text('Delete activity'),
                                  content: Text('Are you sure you want to delete this activity?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }, 
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        //delete field
                                        
                                        Firestore().removeActivity(fieldIndex, index);
                                        Navigator.of(context).pop();
                                        _isEditing=true;
                                        await Future.delayed(Duration(seconds: 1));
                                        _isEditing=false;
                                        setState(() {});
                                        
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              );
            }
              else {
                return Center(child: Text('No activities found'));
              }
          }
        }
      ),  
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 153, 194, 162),
        onPressed: ()=> showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text('Add Activity'),
                content: Column(
                  children: [
                    TextField(
                      controller: nameController ,
                      decoration: InputDecoration(
                        labelText: 'Activity Name',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Activity Description',
                      ),
                    ),
                  ],  
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      String name = nameController.text;
                      String description= descriptionController.text;
                      Activity newActivity = Activity(name: name, description: description, date: DateTime.now().toString());
                      await Firestore().addActivity(newActivity.toMap(), fieldIndex);
                      Navigator.of(context).pop();
                      _isEditing=true;
                      await Future.delayed(Duration(seconds: 1));
                      _isEditing=false;
                      setState(() {});
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            );
          }
        ) ,
        child: Icon(Icons.add),
      )
    );

  }
  

}
