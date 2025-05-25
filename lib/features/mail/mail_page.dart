// lib/features/mail/mail_page.dart
import 'package:flutter/material.dart';

class MailPage extends StatelessWidget {
  const MailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mail / Messages")),
      body: const Center(child: Text("In-App Messages - Coming Soon!")),
    );
  }
}
