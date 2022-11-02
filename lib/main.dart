import 'package:flutter/material.dart';
import 'package:sqflite_flutter/screen/home/home.dart';

void main() {
  runApp(MaterialApp(
    title: 'Car SQFLITE - Flutter',
    theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.black,
        )),
    home: const HomeScreen(),
  ));
}
