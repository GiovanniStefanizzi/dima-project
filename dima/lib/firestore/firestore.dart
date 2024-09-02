import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima/models/activity_model.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/models/user_model.dart';
import 'package:dima/auth/firebase_auth/auth_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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

  Future deleteUser() async {
    String? userId = AuthService().getCurrentUserId();
    try{
      CollectionReference users = FirebaseFirestore.instance.collection("users");
      QuerySnapshot querySnapshot = await users.where('_uid', isEqualTo: userId).get();
      DocumentReference documentReference = querySnapshot.docs.first.reference;
      await documentReference.delete();
    }
    catch(e){
      print(e.toString());
    }
  }

  //write new field
  Future writeField(Map<String, dynamic> field) async {
    String? userId = AuthService().getCurrentUserId();
    //print( "userId: $userId");
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

  Future removeField(int index) async {
    String? userId = AuthService().getCurrentUserId();
    User_model? user = await getCurrentUser();
    Map<String, dynamic> userMap;
    //print( "userId: $userId");

    user?.fields.removeAt(index);
    userMap = user!.toMap();
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    QuerySnapshot querySnapshot = await users.where('_uid', isEqualTo: userId).get();
    DocumentReference docRef = querySnapshot.docs.first.reference;

    FirebaseFirestore.instance.runTransaction((transaction)  async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        print('Documento non trovato');
        return;
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> fields = data['fields'];

      if (fields.length > index) {
        // Rimuovi l'elemento dalla lista
        fields.removeAt(index);
        // Applica l'aggiornamento alla transazione
        transaction.update(docRef, {'fields': fields});

        print('Lista aggiornata con successo!');
      } else {
        print('Indice esterno non valido');
      }
    });catchError(e) {
      print('Errore durante laggiornamento' );
    }
  }
 
  
  Future addActivity(Map<String, dynamic> activity, int externalIndex) async {
    Activity newActivity = Activity.fromMap(activity);
    String? userId = AuthService().getCurrentUserId();
    User_model? user = await getCurrentUser();
    Map<String, dynamic> userMap;
    //print( "userId: $userId");
    
    user?.fields[externalIndex].activities.add(newActivity);
    userMap = user!.toMap();
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    QuerySnapshot querySnapshot = await users.where('_uid', isEqualTo: userId).get();
    DocumentReference docRef = querySnapshot.docs.first.reference;
    FirebaseFirestore.instance.runTransaction((transaction)  async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        print('Documento non trovato');
        return;
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> fields = data['fields'];

      if (fields.length > externalIndex) {
        // Aggiungi l'elemento alla lista interna specificata
        List<dynamic> internalList = List.from(fields[externalIndex]['activities']);
        internalList.add(activity);

        // Aggiorna solo l'elemento della lista esterna con la lista interna aggiornata
        fields[externalIndex]['activities'] = internalList;

        // Applica l'aggiornamento alla transazione
        transaction.update(docRef, {'fields': fields});

        print('Lista aggiornata con successo!');
      } else {
        print('Indice esterno non valido');
      }
    });catchError(e) {
      print('Errore durante laggiornamento' );
    }
  }
  
  Future removeActivity(int externalIndex, int internalIndex) async {
    String? userId = AuthService().getCurrentUserId();
    User_model? user = await getCurrentUser();
    Map<String, dynamic> userMap;
    //print( "userId: $userId");

    user?.fields[externalIndex].activities.removeAt(internalIndex);
    userMap = user!.toMap();
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    QuerySnapshot querySnapshot = await users.where('_uid', isEqualTo: userId).get();
    DocumentReference docRef = querySnapshot.docs.first.reference;

    FirebaseFirestore.instance.runTransaction((transaction)  async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        print('Documento non trovato');
        return;
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> fields = data['fields'];

      if (fields.length > externalIndex) {
        // Rimuovi l'elemento dalla lista interna specificata
        List<dynamic> internalList = List.from(fields[externalIndex]['activities']);
        internalList.removeAt(internalIndex);

        // Aggiorna solo l'elemento della lista esterna con la lista interna aggiornata
        fields[externalIndex]['activities'] = internalList;

        // Applica l'aggiornamento alla transazione
        transaction.update(docRef, {'fields': fields});

        print('Lista aggiornata con successo!');
      } else {
        print('Indice esterno non valido');
      }
    });catchError(e) {
      print('Errore durante laggiornamento' );
    }
  }

  Future<User_model?> getCurrentUser() async {
    String? userId=AuthService().getCurrentUserId();
    //print( "userId: $userId");
    //String userId="0IjeLFlmtydMGsFarrTs6l5Nt0r1";

    try{
      CollectionReference users = FirebaseFirestore.instance.collection("users");
      QuerySnapshot querySnapshot = await users.where('_uid', isEqualTo: userId).get();
      QueryDocumentSnapshot firstDocument = querySnapshot.docs.first;
      DocumentSnapshot documentSnapshot = firstDocument as DocumentSnapshot;
      if(documentSnapshot.exists){
        Map<String, dynamic> documentData = documentSnapshot.data() as Map<String, dynamic>;
        //print(documentData);
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

  Future<Field_model> getField(int index) async {
    User_model? user = await getCurrentUser();
    return user!.fields[index];
  }

  updateUsername(String text) {
    String? userId = AuthService().getCurrentUserId();
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    users.where('_uid', isEqualTo: userId).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'username': text});
      });
    });

  }

  updateField(int index, String name, String cropType, String datePlanted, bool frostAlert, bool hailAlert) async {
    Field_model old_field = await getField(index);
    //empty list of activities
    List<Activity> oldActivities = old_field.activities;
    List<Activity> activities = []; 
    Field_model updated_field = Field_model(name: name, cropType: cropType, datePlanted: datePlanted, frostAlert: frostAlert, hailAlert: hailAlert, points: old_field.points, activities: activities);
    String? userId = AuthService().getCurrentUserId();
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    //update the document at the index with the updated field
    users.where('_uid', isEqualTo: userId).get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        List<dynamic> fields = doc['fields'];
        fields[index] = updated_field.toMap();
        for (int i = 0; i < oldActivities.length; i++) {
          addActivity(oldActivities[i].toMap(), index);
        }
        doc.reference.update({'fields': fields});
      });
    });

  }


    
    

}
