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
    print('No internet connection');
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize/view.devicePixelRatio;
    double width = size.width;
    double height = size.height;
    var shortestSide = width < height ? width : height;
    print(shortestSide);
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
    print('Internet connection available');

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );


    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize/view.devicePixelRatio;
    double width = size.width;
    double height = size.height;
    var shortestSide = width < height ? width : height;
    print(shortestSide);
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
    //await FirebaseAuth.instance.signOut();

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
       //if(widget._isConnected){ return AuthStateChecker()},
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

class HelloWorld extends StatelessWidget {
  // Constructor of HelloWorld
  // "{...}" means that the parameters inside the brackets are optional
  // "Key?" means that the parameter key can be null
  const HelloWorld({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Hello World",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500));
  }
}

class HelloWorldPlus extends StatelessWidget {
  final int number;
  final Color color;

  // Constructor "Initializing formals"
  // When possible, it is recommended to use this type of constructor
  // We made the parameter "color" optional 
  // and set its default value to Colors.red 
  const HelloWorldPlus(this.number, {this.color = Colors.red, Key? key})
      : super(key: key);

  // Named Constructor
  const HelloWorldPlus.withBlue(this.number, {Key? key})
  // This block of code is called before the constructor
  // The call to the super class "super(key: key)" must
  // must always be the last one of the block
      : color = Colors.blue,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      // You can use ${} to interpolate the value of Dart expressions within strings.
      // The curly braces can be omitted when evaluating identifiers:
      "Hello World $number",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: color),
    );
  }
}

// HelloWorldGenerator generates a list of "hello worlds"
// It takes 'count' which represents the number of "hello worlds" to return
// Each "hello world" has a different color
class HelloWorldGenerator extends StatelessWidget {
  final int count;

  const HelloWorldGenerator(this.count, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dart support generic types
    List<Widget> childList = [];
    for (int i = 0; i < count; i++) {
      childList.add(
          // Color.fromRGBO
          // RGBO (Red Green Blue Opacity)
          // RGB are integers and opacity is a double
          // The primitive type double in Dart provides 64 bits of integer precision
          // on mobile devices they provide only 53 bits of integer precision
          // due to Javascript constraints
          HelloWorldPlus(i,
              color: Color.fromRGBO(
                16 * i % 255, // red
                32 * i % 255, // green
                64 * i % 255, // blue
                1.0,          // opacity
              )));
    }
    return Column(children: childList);
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
          return const Homepage();  // La tua home page quando l'utente è autenticato
        } else {
          return const Login();  // La tua pagina di login quando l'utente non è autenticato
        }
      },
    );
  }
}