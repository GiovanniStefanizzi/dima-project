import 'package:dima/pages/field_list/field_list_screen.dart';
import 'package:dima/pages/map/map_screen.dart';
import 'package:dima/pages/register/register.dart';
import 'package:flutter/material.dart';
import 'pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/field_details/field_details_screen.dart';

// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

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
      home: FieldListScreen(),
      routes:{
        '/register': (context)=>Register(),
        '/login': (context)=>Login(),
        '/add_field': (context)=>MapScreen(),
        '/field_details': (context)=>FieldDetailsScreen(),
      }
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