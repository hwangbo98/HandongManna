import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        body : Center(
          child : Image.asset('assets/HandongMannaLogo.png'),
          // color: Colors.blueAccent,
          // child : Text('Handong Manna',
          //     style: TextStyle(
          //       fontSize: 50.0, fontWeight:  FontWeight.bold,
          //       fontStyle: FontStyle.italic,
          //       fontFamily: 'Arial',
          //       color: Colors.white,
          //     ),
        ),
      ),
    );
    // );
  }
}

