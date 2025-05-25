// lib/features/tutorial/tutorial_page.dart
import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tutorial")),
      body: Padding( // Added Padding
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "App Tutorial - Coming Soon!",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
