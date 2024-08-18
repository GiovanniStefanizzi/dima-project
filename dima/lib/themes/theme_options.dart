import 'package:flutter/material.dart';

class ThemeOptions {
  
  static ButtonStyle elevatedButtonStyle (){
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.black87, 
      backgroundColor: const Color.fromARGB(255, 153, 194, 162),
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );  
  }

  static textButtonStyle (){
    return TextButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 153, 194, 162), 
      minimumSize: Size(88, 36),
      //padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    );
  }

  static InputDecoration inputDecoration(String labelText, String hintText){
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(15),
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