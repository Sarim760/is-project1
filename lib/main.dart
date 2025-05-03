import 'package:flutter/material.dart';
import 'package:isproject/screens/home_screen.dart';

void main() {
  runApp(StegoApp());
}

class StegoApp extends StatelessWidget {
  const StegoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Steganography',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
