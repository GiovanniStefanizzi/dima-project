import 'package:dima/models/activity_model.dart';
import 'package:dima/models/field_model.dart';

class User_model{

  final String uid;
  final String email;
  final String username;
  
  List<Field_model> fields = [];
  


  User_model({required this.uid, required this.email, required this.username, required this.fields});
  User_model.createUser({required this.uid, required this.email, required this.username});

  factory User_model.fromMap(Map<String, dynamic> data) {

    return User_model(
      uid: data['_uid'],
      email: data['email'],
      username: data['username'],
      fields: (data['fields'] as List<dynamic>?)
          ?.map((fieldJson) => Field_model.fromMap(fieldJson))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_uid': uid,
      'email': email,
      'username': username,
    };
  }

  List<Field_model> getFields(){
    return fields;
  }

  
}