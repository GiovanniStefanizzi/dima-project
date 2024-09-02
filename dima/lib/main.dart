import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dima/pages/field_details/modify_field_screen.dart';
import 'package:dima/pages/field_list/field_list_screen.dart';
import 'package:dima/pages/homepage.dart';
import 'package:dima/pages/map/map_screen.dart';
import 'package:dima/pages/register/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/field_details/field_details_screen.dart';
import 'utils/notification_utils.dart';
import 'utils/background_utils.dart';

// ...

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  if(connectivityResult.contains(ConnectivityResult.none)){
    //no internet connection
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize/view.devicePixelRatio;
    double width = size.width;
    double height = size.height;
    var shortestSide = width < height ? width : height;

    final bool useMobileLayout = shortestSide < 600;
    

    if(useMobileLayout){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    else{
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    runApp(const MyApp(false));
  }
  else{
    //internet connection available

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );


    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize/view.devicePixelRatio;
    double width = size.width;
    double height = size.height;
    var shortestSide = width < height ? width : height;
   
    final bool useMobileLayout = shortestSide < 600;

    if(useMobileLayout){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    else{
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    // Inizializza le notifiche
    NotificationService().initNotification();


    // Inizializza il background fetch
    initializeBackgroundFetch();

    runApp(const MyApp(true));
  }
  
}

class MyApp extends StatefulWidget { 
  final bool isConnected;
  const MyApp(
    @required  this.isConnected,
    {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    

    return MaterialApp(
      title: 'Dima',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home:Builder(builder: (context) {
        if(widget.isConnected){
          return AuthStateChecker();
        }
        else{
          return const Scaffold(
            body: Center(
              child: Text('No internet connection'),
            ),
          );
        }
      }),
      routes:{
        '/register': (context)=>Register(),
        '/login': (context)=>Login(),
        '/add_field': (context)=>MapScreen(),
        '/field_details': (context)=>FieldDetailsScreen(),
        '/field_list': (context)=>FieldListScreen(),
        '/homepage': (context)=>Homepage(),
        '/modify_field': (context)=>ModifyFieldScreen(),
      }
      );
  }
  
  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
            title: Text("Internet needed!"),
            content: Text("You may want to exit the app here"),
          ),
    );
  }
}


class AuthStateChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return const Homepage();  
        } else {
          return const Login();
        }
      },
    );
  }
}