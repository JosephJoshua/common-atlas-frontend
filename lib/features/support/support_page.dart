import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // Optional: if URL launching is implemented
import 'package:common_atlas_frontend/widgets/app_drawer.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(top:0),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0), // Add padding to the answer text
          child: Text(answer, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SUPPORT"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Frequently Asked Questions", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildFAQItem(
                context,
                "How do I reset my password?",
                "To reset your password, navigate to the 'Settings' page accessible from your Profile, then select 'Account Settings'. You'll find an option to change or reset your password there. If you encounter issues, please use the contact form below.",
              ),
              _buildFAQItem(
                context,
                "Where can I find my points?",
                "Your current points balance is displayed on your Profile page, right below your name. You can also see your points in the 'Points Store' section of the Store page before making a redemption.",
              ),
              _buildFAQItem(
                context,
                "Is this app free?",
                "Yes, the basic features of Common Atlas, including route exploration and point collection, are completely free. We may offer optional premium plans in the future with additional exclusive features.",
              ),
              _buildFAQItem(
                context,
                "How is my location data used?",
                "Your location data is used to help you navigate routes and discover checkpoints. We prioritize your privacy. For more details, please review our Privacy Policy in the 'About' section.",
              ),
              const SizedBox(height: 30), // Increased spacing

              Text("Contact Us", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                "For further assistance, feature requests, or bug reports, please email us at:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SelectableText( // Makes it easy to copy the email
                "support@commonatlas.dev",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Or visit our support website:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              TextButton.icon(
                icon: Icon(Icons.link, color: Theme.of(context).colorScheme.primary),
                label: Text(
                  "commonatlas.dev/support",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  // TODO: Launch URL if url_launcher is used
                  // For example: await launchUrl(Uri.parse("https://commonatlas.dev/support"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("URL Launching not yet implemented.")),
                  );
                  print("Visit website button tapped");
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
              ),
              const SizedBox(height: 30), // Increased spacing

              Text("About Common Atlas", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Version: 1.0.0 (Prototype)", style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 5),
              Text(
                "Common Atlas is your guide to exploring the city in a fun and interactive way! Discover hidden gems, complete challenges, and learn more about your surroundings.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
