import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width:  MediaQuery.of(context).size.width * 0.5,
          height:  MediaQuery.of(context).size.height * 0.5,
          child: const Text('My App'),
        )
      )
    );
  }
}