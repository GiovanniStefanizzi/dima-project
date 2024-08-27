import 'package:dima/auth/firebase_auth/auth_util.dart';
import 'package:dima/themes/theme_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../register/register_screen_mock.dart';

class LoginMock extends StatefulWidget {
  const LoginMock({super.key});
  
  @override
  State<LoginMock> createState() => _LoginStateMock();
}

class _LoginStateMock extends State<LoginMock> {
  //final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  
  bool _isSigning=false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool useMobileLayout = screenWidth < 600;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    if(useMobileLayout){
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 197, 237, 172),
              
              ),
              
            
              child: Container(
                width:  screenWidth * 0.8,
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
                      SizedBox(
                        height: screenHeight*0.045,
                        width: screenWidth*0.5,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: screenWidth*0.045,
                          ),                    
                          textAlignVertical: TextAlignVertical.center,  
                          controller: _emailController,
                          decoration: ThemeOptions.inputDecoration('email', 'email', context),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: screenHeight*0.045,
                            width: screenWidth*0.5,
                            child: TextFormField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: ThemeOptions.inputDecoration('password', 'password', context),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.03),
                          TextButton(
                            key: new Key('signupbutton'),
                            style: ThemeOptions.textButtonStyle(),
                            onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterMock()));
                          },
                          child: const Text('New user? Sign up!'))
                        ],
                      ),
                      SizedBox(
                        
                        width: screenWidth*0.5,
                        height: screenHeight*0.04,
                        child: ElevatedButton(
                          style: ThemeOptions.elevatedButtonStyle(context),
                          onPressed: () async {
                            //_signIn();
                          },
                          child: const Text('sign in')),
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
                      ]))),
            ),
          )
        );
    }
    else{
      //TABLET
      return Scaffold(
          //resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 197, 237, 172),
              
              ),
              
            
              child: Container(
                width:  screenWidth * 0.6,
                height: screenHeight * 0.7,
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
                margin: EdgeInsets.only(top: screenHeight*0.15, bottom: screenHeight*0.15, left: screenWidth*0.35, right: screenWidth*0.35),
                padding:  EdgeInsets.all(screenWidth*0.04),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Appazza", style: TextStyle(color:const Color.fromARGB(255, 122, 145, 141), fontSize: screenWidth*0.05, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: screenHeight*0.045,
                        width: screenWidth*0.5,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: screenWidth*0.015,
                          ),
                          key: new Key('emailfield') ,                 
                          textAlignVertical: TextAlignVertical.center,  
                          controller: _emailController,
                          decoration: ThemeOptions.inputDecorationTablet('email', 'email', context),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: screenHeight*0.045,
                            width: screenWidth*0.5,
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: screenWidth*0.015,
                              ),
                              obscureText: true,
                              controller: _passwordController,
                              decoration: ThemeOptions.inputDecorationTablet('password', 'password', context),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.03),
                          TextButton(
                            key: new Key('signupbutton'),
                            style: ThemeOptions.textButtonStyleTablet(),
                            onPressed: () {
                            print('test');
                          },
                          child: const Text('New user? Sign up!'))
                        ],
                      ),
                      SizedBox(
                        
                        width: screenWidth*0.5,
                        height: screenHeight*0.04,
                        child: ElevatedButton(
                          key: new Key('signinbutton'),
                          style: ThemeOptions.elevatedButtonStyleTablet(context),
                          onPressed: () async {
                            //_signIn();
                          },
                          child: const Text('sign in')),
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
                      ]))),
            ),
          )
        );
    }
    
  }

//void _signInWithGoogle() async {
//    UserCredential? user = await _auth.signWithGoogle();
//    if (user.user != null) {
//      print("User is successfully signed in with google");
//      Navigator.pushNamedAndRemoveUntil(context, "/homepage",(route) => false);
//    } else {
//      print("some error occured");
//    }
//}


//void _signIn() async {
//    setState(() {
//      _isSigning = true;
//    });
//
//    String email = _emailController.text;
//    String password = _passwordController.text;
//
//    User? user = await _auth.signInWithEmailAndPassword(email, password);
//
//    setState(() {
//      _isSigning = false;
//    });
//
//    if (user != null) {
//      
//      print("User is successfully signed in");
//      Navigator.pushNamedAndRemoveUntil(context, "/homepage",(route) => false);
//    } else {
//      Fluttertoast.showToast(
//        msg: "login failed",
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIosWeb: 1,
//        textColor: Colors.red,
//        backgroundColor: Colors.white,
//        fontSize: 16.0
//    );
//    }
//  }

}
