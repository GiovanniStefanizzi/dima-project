import 'package:dima/pages/field_list/field_list_screen.dart';
import 'package:dima/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();


  // sign up with email and password
  Future <User?> signUpWithEmailAndPassword( String username, String email, String password) async {
    
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,);

        User_model user = User_model.createUser(uid: credential.user!.uid, email: email, username: username);
        await Firestore().writeUser(user.toMap());
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  // sign in with email and password
  Future <User?> signInWithEmailAndPassword(String email, String password) async {
    
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserCredential> signWithGoogle () async {
    print('signing in with google');
    try{
      await _googleSignIn.disconnect();
    }
    catch(e){
      print(e.toString());
    }
    
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    //print('credential: $credential');
    


    // Once signed in, return the UserCredential
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
    //print('result: $result');

    if (result.additionalUserInfo!.isNewUser) {
      User_model user = User_model.createUser(uid: result.user!.uid, email: result.user!.email!, username: result.user!.displayName!);
      await Firestore().writeUser(user.toMap());
    }


    return result;
  }

  // sign out
  Future logOut() async {
    try {
      await _auth.signOut();
      print('signed out');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }



  
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;
      return userId;
    } else {
      print('User is not signed in.');
      return null;
    }
  }

  Future deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await Firestore().deleteUser();
      await user.delete();
    } else {
      print('User is not signed in.');
    }
  }

}