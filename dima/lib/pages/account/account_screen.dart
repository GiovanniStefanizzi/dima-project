import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../auth/firebase_auth/auth_util.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _accountScreenState();
}

class _accountScreenState extends State<AccountScreen> {
  bool _isEditing = false;
  final AuthService _auth=AuthService();

  Future<String> getUsername() async {
    User_model? user = await Firestore().getCurrentUser();
    return user!.username;
  }

  Future<String> getEmail() async {
    User_model? user = await Firestore().getCurrentUser();
    return user!.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, 
            //put size equal to 10% of the screen height 
            size: 0.2 * MediaQuery.of(context).size.height),
            FutureBuilder(future: getUsername(), builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || _isEditing) {
                return CircularProgressIndicator();
              } else {
                return Text(snapshot.data.toString());
              }
            }),
            FutureBuilder(future: getEmail(), builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Text(snapshot.data.toString());
              }
            }),
            ElevatedButton(
              onPressed: () {
                //alert with text field to change username
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final TextEditingController _controller = TextEditingController();
                    return AlertDialog(
                      title: const Text('Change username'),
                      content: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(hintText: 'Enter new username'),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await Firestore().updateUsername(_controller.text);

                            _isEditing=true;
                            Navigator.of(context).pop();
                            await Future.delayed(Duration(milliseconds: 400));
                            _isEditing=false;
                            setState(() {});
                          },
                          child: const Text('Change'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Change username'),
            ),
            TextButton(
              onPressed: () async{
                await _auth.logOut();
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Sign out'),
            ),
            TextButton(
              onPressed: () async {
                await AuthService().deleteUser();
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Delete account'),
            ),
          ],
        ),
      ),
    );
  }
}