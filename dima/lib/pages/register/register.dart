import 'package:flutter/material.dart';
import 'package:dima/auth/firebase_auth/auth_util.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Register extends StatefulWidget {

  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
final AuthService _auth = AuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 19, 243, 217),
                  Color.fromARGB(255, 22, 190, 67)
                ],
              ),
            ),
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.only(top: 150, bottom: 300, left: 40, right: 40),
              padding: const EdgeInsets.all(20),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'username',
                        hintText: 'username',
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)
                        )
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'passwords',
                        hintText: 'passwords',
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)
                        )
                      ),
                    ),
                    Column(
                      children: [
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'repeat passwords',
                            hintText: 'repeat passwords',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),                              ),
                          ),
                          //todo: validator: ,
                        ),
                        const SizedBox(height: 5),
                        TextButton(onPressed: () {},
                        child: const Text('Already have an account? Sign in!'))
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('sign up')),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('sign in with Google'))
                    ]))),
          ),
        ));
  }

  void _signUp() async {

    setState(() {
      isSigningUp = true;
    });


    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      print("Sign up successful");
    } else {
      print("Sign up failed");
    }
  }
}
