// lib/features/tutorial/tutorial_page.dart
import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tutorial")),
      body: const Center(child: Text("App Tutorial - Coming Soon!")),
    );
  }
}
