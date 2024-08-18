import 'package:dima/themes/theme_options.dart';
import 'package:flutter/material.dart';
import 'package:dima/auth/firebase_auth/auth_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


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

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 197, 237, 172)
            ),
            child: Container(
              height: screenHeight * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(44, 0, 0, 0),
                    blurRadius: 25.0,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 0.0),
                  )
                ],
                
              ),
              margin: EdgeInsets.only(top: screenHeight*0.175, bottom: screenHeight*0.175, left: screenWidth*0.15, right: screenWidth*0.15),
              padding:  EdgeInsets.all(screenWidth*0.05),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Appazza", style: TextStyle(color:const Color.fromARGB(255, 122, 145, 141), fontSize: screenWidth*0.08, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _emailController,
                      decoration: ThemeOptions.inputDecoration('email', 'email'),
                    ),
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
                      obscureText: true,
                      controller: _passwordController,
                      decoration: ThemeOptions.inputDecoration('password', 'password'),
                      validator: (val){
                        if(val!.length < 8){
                          return 'password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    Column(
                      children: [
                        TextFormField(
                          obscureText: true,
                          decoration: ThemeOptions.inputDecoration('repeat passwords', 'repeat passwords'),
                          validator: (val){
                            if(val != _passwordController.text){
                              return 'passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: screenHeight *0.03),
                        TextButton(
                          style: ThemeOptions.textButtonStyle(),
                          onPressed: () {
                          
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
      Fluttertoast.showToast(
        msg: "signup failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.red,
        fontSize: 16.0
    );
    }
  }
}
