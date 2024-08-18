import 'package:dima/themes/theme_options.dart';
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
                      decoration: ThemeOptions.inputDecoration('username', 'username'),
                      //decoration: InputDecoration(
                      //  labelText: 'username',
                      //  hintText: 'username',
                      //  border: OutlineInputBorder(
                      //  borderRadius: BorderRadius.circular(25)
                      //  )
                      //),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: ThemeOptions.inputDecoration('email', 'email'),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: ThemeOptions.inputDecoration('password', 'password'),
                    ),
                    Column(
                      children: [
                        TextFormField(
                          obscureText: true,
                          decoration: ThemeOptions.inputDecoration('repeat passwords', 'repeat passwords'),
                          //todo: validator: ,
                        ),
                        const SizedBox(height: 5),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Already have an account? Sign in!'))
                      ],
                    ),
                    ElevatedButton(
                      style: ThemeOptions.elevatedButtonStyle(),
                      onPressed: () async {
                        _signUp();
                      },
                      child: const Text('sign up')),
                    ElevatedButton(
                      style: ThemeOptions.elevatedButtonStyle(),
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

    User? user = await _auth.signUpWithEmailAndPassword(username, email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      print("Sign up successful");
      Navigator.pushNamedAndRemoveUntil(context, "/homepage",(route) => false);
    } else {
      print("Sign up failed");
    }
  }
}
