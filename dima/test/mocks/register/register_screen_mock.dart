import 'package:dima/themes/theme_options.dart';
import 'package:flutter/material.dart';
import 'package:dima/auth/firebase_auth/auth_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../homepage/homepage_mock.dart';


class RegisterMock extends StatefulWidget {

  const RegisterMock({super.key});

  @override
  State<RegisterMock> createState() => _RegisterMockState();
}

class _RegisterMockState extends State<RegisterMock> {
//final AuthService _auth = AuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  bool isSigningUp = false;

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool useMobileLayout = screenWidth < 600;

    if(useMobileLayout){
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
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(key: Key('register'), "Appazza", style: TextStyle(color:const Color.fromARGB(255, 122, 145, 141), fontSize: screenWidth*0.08, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: screenHeight*0.045,
                          width: screenWidth*0.5,
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: screenWidth*0.045,
                            ),  
                            key: Key('email'), 
                            controller: _emailController,
                            decoration: ThemeOptions.inputDecoration('email', 'email', context),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight*0.045,
                          width: screenWidth*0.5,
                          child: TextFormField(
                            key: Key('username'),
                            style: TextStyle(
                              fontSize: screenWidth*0.045,
                            ),   
                            controller: _usernameController,
                            decoration: ThemeOptions.inputDecoration('username', 'username', context),
                            //decoration: InputDecoration(
                            //  labelText: 'username',
                            //  hintText: 'username',
                            //  border: OutlineInputBorder(
                            //  borderRadius: BorderRadius.circular(25)
                            //  )
                            //),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight*0.045,
                          width: screenWidth*0.5,
                          child: TextFormField( 
                            key: Key('password'),
                            style: TextStyle(
                              fontSize: screenWidth*0.045,
                            ),                   
                            obscureText: true,
                            controller: _passwordController,
                            decoration: ThemeOptions.inputDecoration('password', 'password', context),
                            
                            validator: (val){
                              if(val!.length < 8){
                                //return "password must be at least 8 characters long";
                                Fluttertoast.showToast(
                                  msg: "password must be at least 8 characters long",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.red,
                                  fontSize: 16.0
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: screenHeight*0.045,
                              width: screenWidth*0.5,
                              child: TextFormField(
                                key: Key('repeatPassword'),
                                style: TextStyle(
                                  fontSize: screenWidth*0.045,
                                ),    
                                obscureText: true,
                                controller: _repeatPasswordController,
                                decoration: ThemeOptions.inputDecoration('repeat password', 'repeat password',context),
                                validator: (val){
                                  if(val != _passwordController.text){
                                    return "passwords do not match";
                                    //Fluttertoast.showToast(
                                    //  msg: "passwords do not match",
                                    //  toastLength: Toast.LENGTH_SHORT,
                                    //  gravity: ToastGravity.BOTTOM,
                                    //  timeInSecForIosWeb: 1,
                                    //  textColor: Colors.red,
                                    //  fontSize: 16.0,
                                    //);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight *0.03),
                            SizedBox(
                              child: TextButton(
                                style: ThemeOptions.textButtonStyle(),
                                onPressed: () {
                                
                                Navigator.pop(context);
                              },
                              child: const Column(
                                children: [
                                  Center(child: Text('Already have an account?')),
                                  Center(child: Text('Sign in!'))
                                ],
                              ),
                            ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: screenWidth*0.5,
                          height: screenHeight*0.04,
                          child: ElevatedButton(
                            key: Key('registerbutton'),
                            style: ThemeOptions.elevatedButtonStyle(context),
                            onPressed: () async {
                              _signUpMock();
                            },
                            child: const Text('sign up')),
                        ),
                        SizedBox(
                          width: screenWidth*0.5,
                          height: screenHeight*0.04,
                          child: ElevatedButton(
                            style: ThemeOptions.elevatedButtonStyle(context),
                            onPressed: () {
                              //_signInWithGoogle();
                            },
                            child: const Text('sign in with Google')),
                        )
                        ]),
                  ))),
            ),
          )
        );
      }
    else{


      //TABLET LAYOUT


      
      return Scaffold(
          //resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 197, 237, 172)
              ),
              child: Container(
                height: screenHeight * 0.75,
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
                margin: EdgeInsets.only(top: screenHeight*0.15, bottom: screenHeight*0.15, left: screenWidth*0.35, right: screenWidth*0.35),
                padding:  EdgeInsets.all(screenWidth*0.035),
                child: Form(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Appazza", style: TextStyle(color:const Color.fromARGB(255, 122, 145, 141), fontSize: screenWidth*0.05, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: screenHeight*0.045,
                          width: screenWidth*0.5,
                          child: TextFormField(
                            key: Key('email'),
                            style: TextStyle(
                              fontSize: screenWidth*0.015,
                            ),   
                            textAlignVertical: TextAlignVertical.center, 
                            controller: _emailController,
                            decoration: ThemeOptions.inputDecorationTablet('email', 'email', context),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight*0.045,
                          width: screenWidth*0.5,
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: screenWidth*0.015,
                            ), 
                            textAlignVertical: TextAlignVertical.center,   
                            controller: _usernameController,
                            decoration: ThemeOptions.inputDecorationTablet('username', 'username', context),
                            //decoration: InputDecoration(
                            //  labelText: 'username',
                            //  hintText: 'username',
                            //  border: OutlineInputBorder(
                            //  borderRadius: BorderRadius.circular(25)
                            //  )
                            //),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight*0.045,
                          width: screenWidth*0.5,
                          child: TextFormField(  
                            style: TextStyle(
                              fontSize: screenWidth*0.015,
                            ),              
                            textAlignVertical: TextAlignVertical.center,      
                            obscureText: true,
                            controller: _passwordController,
                            decoration: ThemeOptions.inputDecorationTablet('password', 'password', context),
                            
                            validator: (val){
                              if(val!.length < 8){
                                return "password must be at least 8 characters long";
                                //Fluttertoast.showToast(
                                //  msg: "password must be at least 8 characters long",
                                //  toastLength: Toast.LENGTH_SHORT,
                                //  gravity: ToastGravity.BOTTOM,
                                //  timeInSecForIosWeb: 1,
                                //  textColor: Colors.red,
                                //  fontSize: 16.0
                                //);
                              }
                              return null;
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: screenHeight*0.045,
                              width: screenWidth*0.5,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: screenWidth*0.015,
                                  
                                ), 
                                textAlignVertical: TextAlignVertical.center,  
                                obscureText: true,
                                controller: _repeatPasswordController,
                                decoration: ThemeOptions.inputDecorationTablet('repeat password', 'repeat password',context),
                                validator: (val){
                                  if(val != _passwordController.text){
                                    return "passwords do not match";
                                    //Fluttertoast.showToast(
                                    //  msg: "passwords do not match",
                                    //  toastLength: Toast.LENGTH_SHORT,
                                    //  gravity: ToastGravity.BOTTOM,
                                    //  timeInSecForIosWeb: 1,
                                    //  textColor: Colors.red,
                                    //  fontSize: 16.0,
                                    //);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight *0.03),
                            SizedBox(
                              child: TextButton(
                                style: ThemeOptions.textButtonStyleTablet(),
                                onPressed: () {
                                
                                Navigator.pop(context);
                              },
                              child: const Column(
                                children: [
                                  Center(child: Text('Already have an account?')),
                                  Center(child: Text('Sign in!'))
                                ],
                              ),
                            ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: screenWidth*0.5,
                          height: screenHeight*0.04,
                          child: ElevatedButton(
                            style: ThemeOptions.elevatedButtonStyleTablet(context),
                            onPressed: () async {
                              //_signUp();
                            },
                            child: const Text('sign up')),
                        ),
                        SizedBox(
                          width: screenWidth*0.5,
                          height: screenHeight*0.04,
                          child: ElevatedButton(
                            style: ThemeOptions.elevatedButtonStyleTablet(context),
                            onPressed: () {
                              //_signInWithGoogle();
                            },
                            child: const Text('sign in with Google')),
                        )
                        ]),
                  ))),
            ),
          )
        );
    }
  }
  
  void _signUpMock() {
    if(_passwordController.text.length < 8){
      Fluttertoast.showToast(
        msg: "password must be at least 8 characters long",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.red,
        fontSize: 16.0
      );
    }
    else if(_passwordController.text != _repeatPasswordController.text){
      Fluttertoast.showToast(
        msg: "passwords do not match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.red,
        fontSize: 16.0,
      );
    }
    else{
      //push to homepage
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomepageMock()));
    }
  }


  
  
}
