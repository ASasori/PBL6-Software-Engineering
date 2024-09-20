import 'package:flutter/material.dart';

class HomeExploreScreen extends StatefulWidget {
  final AnimationController animationController;
  const HomeExploreScreen({super.key, required this.animationController});

  @override
  State<HomeExploreScreen> createState() => _HomeExploreScreenState();
}

class _HomeExploreScreenState extends State<HomeExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hotel Explorer"),
      ),
    );
  }
}
