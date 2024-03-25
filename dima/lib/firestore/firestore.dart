import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/models/user_model.dart';

class Firestore{


  final db = FirebaseFirestore.instance;

  //write new user
  Future writeUser(Map<String, dynamic> user) async {
    try {
      await db.collection('users').add(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //write new field
  Future writeField(Map<String, dynamic> field) async {
    try {
      await db.collection('fields').add(field);
    } catch (e) {
      print(e.toString());
      return null;
    }
  } 


}
