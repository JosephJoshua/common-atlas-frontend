// lib/features/mail/mail_page.dart
import 'package:flutter/material.dart';

class MailPage extends StatelessWidget {
  const MailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mail / Messages")),
      body: Padding( // Added Padding
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "In-App Messages - Coming Soon!",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
