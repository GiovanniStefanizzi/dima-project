import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/models/user_model.dart';
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
                    title: Text(field.name),
                    subtitle: Text(field.cropType),
                    // You can customize the ListTile as needed
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