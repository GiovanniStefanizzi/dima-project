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




class ActivityWidgetMock extends StatefulWidget {
  @override
  _activityWidgetState createState() => _activityWidgetState();
}

class _activityWidgetState extends State<ActivityWidgetMock> {
  bool _isEditing = false;

  
  @override
  Widget build(BuildContext context) {

    List<Activity> activities = [
    Activity(name: 'activity1', description: 'description1', date: DateTime.now().toString()),
    Activity(name: 'activity2', description: 'description2', date: DateTime.now().toString()),
    Activity(name: 'activity3', description: 'description3', date: DateTime.now().toString()),
  ];
    final int fieldIndex = 1;
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      
      body:  ListView.builder(
              
              itemCount: activities.length,
              itemBuilder: (context, index){
                Activity activity = activities[index];
                return ListTile(
                  title: Text(activity.name, style: TextStyle(fontSize: screenHeight*0.02)),
                  subtitle: Text(activity.description, style: TextStyle(fontSize: screenHeight*0.015)),
                  trailing: Wrap(
                    children: [
                      Text(activity.date.substring(0,10), style: TextStyle(fontSize: screenHeight*0.015, color: Colors.grey)),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: const Color.fromARGB(255, 153, 194, 162),
                                title: const Text('Delete activity'),
                                content: const Text('Are you sure you want to delete this activity?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }, 
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      //delete field
                                      
                                      //Firestore().removeActivity(fieldIndex, index);
                                      Navigator.of(context).pop();
                                      _isEditing=true;
                                      await Future.delayed(const Duration(seconds: 1));
                                      _isEditing=false;
                                      setState(() {});
                                      
                                    },
                                    child: const Text('Delete'),
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
            ),

        
        
      floatingActionButton: FloatingActionButton(
        key: Key('addActivity'),
        backgroundColor: const Color.fromARGB(255, 153, 194, 162),
        onPressed: ()=> showDialog(
          context: context,
          builder: (BuildContext context) {
            return Align(
              alignment: Alignment.center ,
              child: SingleChildScrollView(
                child: AlertDialog(
                  title: const Text('Add Activity'),
                  content: Column(
                    children: [
                      TextField(
                        controller: nameController ,
                        decoration: const InputDecoration(
                          labelText: 'Activity Name',
                        ),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Activity Description',
                        ),
                      ),
                    ],  
                  ),
                  actions: [
                    TextButton(
                      key: Key('cancel'),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        String name = nameController.text;
                        String description= descriptionController.text;
                        Activity newActivity = Activity(name: name, description: description, date: DateTime.now().toString());
                        //await Firestore().addActivity(newActivity.toMap(), fieldIndex);
                        Navigator.of(context).pop();
                        _isEditing=true;
                        await Future.delayed(const Duration(seconds: 1));
                        _isEditing=false;
                        setState(() {});
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            );
          }
        ) ,
        child: const Icon(Icons.add),
      )
    );

  }
  

}
