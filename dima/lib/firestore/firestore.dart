import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/models/user_model.dart';
import 'package:dima/auth/firebase_auth/auth_util.dart';

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
    String? userId = AuthService().getCurrentUserId();
    print( "userId: $userId");
    //String userId="0IjeLFlmtydMGsFarrTs6l5Nt0r1";
    Map<String, dynamic> newElement = field; 
    try{
        CollectionReference users = FirebaseFirestore.instance.collection("users");
        QuerySnapshot querySnapshot = await users.where('_uid', isEqualTo: userId).get();
        DocumentReference documentReference = querySnapshot.docs.first.reference;
        await documentReference.update({
          "fields":FieldValue.arrayUnion([newElement])
        });        
    }
    catch (e){
      print(e.toString());
      return null;
    }
  } 

  Future<User_model?> getCurrentUser() async {
    String? userId=AuthService().getCurrentUserId();
    print( "userId: $userId");
    //String userId="0IjeLFlmtydMGsFarrTs6l5Nt0r1";

    try{
      CollectionReference users = FirebaseFirestore.instance.collection("users");
      QuerySnapshot querySnapshot = await users.where('_uid', isEqualTo: userId).get();
      QueryDocumentSnapshot firstDocument = querySnapshot.docs.first;
      DocumentSnapshot documentSnapshot = firstDocument as DocumentSnapshot;
      if(documentSnapshot.exists){
        Map<String, dynamic> documentData = documentSnapshot.data() as Map<String, dynamic>;
        User_model user_model =User_model.fromMap(documentData);
        return user_model;
      }
      else{
        return null;
      }
    }
    catch (e){
      return null;
    }
  }
}
