import 'package:dima/auth/firebase_auth/auth_util.dart';
import 'package:dima/themes/theme_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
              color: Color.fromARGB(255, 197, 237, 172),
            
            ),
            
          
            child: Container(
              height: screenHeight * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(44, 0, 0, 0),
                    blurRadius: 25.0,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  )
                ],
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.only(top: screenHeight*0.25, bottom: screenHeight*0.25, left: screenWidth*0.15, right: screenWidth*0.15),
              padding:  EdgeInsets.all(screenWidth*0.05),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Appazza", style: TextStyle(color:const Color.fromARGB(255, 122, 145, 141), fontSize: screenWidth*0.08, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _emailController,
                      decoration: ThemeOptions.inputDecoration('email', 'email'),
                    ),
                    Column(
                      children: [
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: ThemeOptions.inputDecoration('password', 'password'),
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
                        SizedBox(height: screenHeight*0.03),
                        TextButton(
                          style: ThemeOptions.textButtonStyle(),
                          onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('New user? Sign up!'))
                      ],
                    ),
                    ElevatedButton(
                      style: ThemeOptions.elevatedButtonStyle(),
                      onPressed: () async {
                        _signIn();
                      },
                      child: const Text('sign in')),
                    ElevatedButton(
                      style: ThemeOptions.elevatedButtonStyle(),
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
      
      print("User is successfully signed in");
      Navigator.pushNamedAndRemoveUntil(context, "/homepage",(route) => false);
    } else {
      Fluttertoast.showToast(
        msg: "some error occurred while logging in",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.red,
        fontSize: 16.0
    );
    }
  }

}
