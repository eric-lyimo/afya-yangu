import 'package:flutter/material.dart';

class AfyaTextTheme {
  AfyaTextTheme._();

  static TextTheme ligtTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32, 
      fontWeight: FontWeight.bold, 
      color: Colors.black
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 32, 
      fontWeight: FontWeight.w600, 
      color: Colors.black,
      
    )  ,      
  );
  static TextTheme darkTextTheme = TextTheme(
        headlineLarge: const TextStyle().copyWith(
      fontSize: 32, 
      fontWeight: FontWeight.bold, 
      color: Colors.white
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 32, 
      fontWeight: FontWeight.w600, 
      color: Colors.white
    )    
  );
}