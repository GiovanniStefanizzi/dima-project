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

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            
          
            child: Container(
              height: screenHeight * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.only(top: screenHeight*0.25, bottom: screenHeight*0.25, left: screenWidth*0.15, right: screenWidth*0.15),
              padding: const EdgeInsets.all(30),
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
                      onPressed: () {
                        
                        _signInWithGoogle();
                      },
                      child: const Text('sign in with Google'))
                    ]))),
          ),
        ));
  }

void _signInWithGoogle() async {
    UserCredential? user = await _auth.signWithGoogle();
    if (user.user != null) {
      print("User is successfully signed in with google");
      Navigator.pushNamedAndRemoveUntil(context, "/homepage",(route) => false);
    } else {
      print("some error occured");
    }
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
      Navigator.pushNamedAndRemoveUntil(context, "/homepage",(route) => false);
    } else {
      print("some error occured");
    }
  }

}
