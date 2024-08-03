import 'dart:ffi';
import 'dart:io';

import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/activity_model.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


Future<List<Activity>> getActivities(field) async {
  User_model? user = await Firestore().getCurrentUser();

  // Check if the user is not null
  if (user != null) {
    // If user is not null, return the fields from the user
    return field.getActivities();
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
  
  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, Object>{}) as Map;
    final Field_model field = arguments['field'] as Field_model;
    final int fieldIndex = arguments['index'] as int;
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      body: FutureBuilder(
        future: getActivities(field),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the future to complete
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
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
                    title: Text(activity.name),
                    subtitle: Text(activity.description),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
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
                                  onPressed: () {
                                    //delete field
                                    Firestore().removeActivity(fieldIndex, index);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
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
        onPressed: ()=> showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
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
                    sleep(const Duration(seconds: 1));
                    Navigator.pop(context);
                  },
                  child: Text('Add'),
                ),
              ],
            );
          }
        ) ,
        child: Icon(Icons.add),
      )
    );

  }
  

}
