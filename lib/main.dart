import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imgscanner/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Desi Dan Bilzerian',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      routes: {
        '/': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
