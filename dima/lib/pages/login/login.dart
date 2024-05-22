import 'package:dima/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  
  bool _isSigning=false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'username',
                        hintText: 'username',
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)
                        )
                      ),
                    ),
                    Column(
                      children: [
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'passwords',
                            hintText: 'passwords',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),                              ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty){
                              return "insert a password";
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5),
                        TextButton(onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('New user? Sign up!'))
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _signIn();
                      },
                      child: const Text('sign in')),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('sign in with Google'))
                    ]))),
          ),
        ));
  }

void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      //TODO: toast (o quel che è)
      print("User is successfully signed in");
      Navigator.pushNamed(context, "/home");
    } else {
      print("some error occured");
    }
  }

}
