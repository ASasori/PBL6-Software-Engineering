import 'package:flutter/material.dart';

class MyTripsScreen extends StatefulWidget {
  final AnimationController animationController;
  const MyTripsScreen({super.key, required this.animationController});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("My Favorite Trips"),
      ),
    );
  }
}
