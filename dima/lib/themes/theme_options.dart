import 'package:flutter/material.dart';

class ThemeOptions {
  
  static ButtonStyle elevatedButtonStyle (BuildContext context){
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.black87, 
      backgroundColor: const Color.fromARGB(255, 153, 194, 162),
      //minimumSize: Size(88, 36),
      //padding: EdgeInsets.symmetric(horizontal: 16),
      textStyle: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.04,
        fontWeight: FontWeight.bold,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );  
  }

  static textButtonStyle (){
    return TextButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 153, 194, 162), 
      //minimumSize: Size(88, 36),
      //padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }

  static InputDecoration inputDecoration(String labelText, String hintText, BuildContext context){
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: MediaQuery.of(context).size.width * 0.04,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: MediaQuery.of(context).size.width * 0.04,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(10),
      border: InputBorder.none,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }

  
}