import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // Optional: if URL launching is implemented
import 'package:common_atlas_frontend/widgets/app_drawer.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
      childrenPadding: const EdgeInsets.all(16.0).copyWith(top: 0, bottom: 10), // Applied padding
      iconColor: Theme.of(context).colorScheme.primary, // Applied color
      collapsedIconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), // Applied color
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0), 
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
              const SizedBox(height: 12), // Consistent spacing
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
              const SizedBox(height: 24), // Adjusted spacing

              Text("Contact Us", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12), // Consistent spacing
              Text(
                "For further assistance, feature requests, or bug reports, please email us at:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4), // Spacing before email
              SelectableText( 
                "support@commonatlas.dev",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12), // Adjusted spacing
              Text(
                "Or visit our support website:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4), // Spacing before link
              TextButton.icon(
                icon: Icon(Icons.link, color: Theme.of(context).colorScheme.primary), // Style applied
                label: Text(
                  "commonatlas.dev/support",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline), // Style applied
                ),
                onPressed: () {
                  // TODO: Launch URL if url_launcher is used
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("URL Launching not yet implemented.")),
                  );
                  print("Visit website button tapped");
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
              ),
              const SizedBox(height: 24), // Adjusted spacing

              Text("About Common Atlas", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12), // Consistent spacing
              Text("Version: 1.0.0 (Prototype)", style: Theme.of(context).textTheme.bodyMedium), // Changed to bodyMedium
              const SizedBox(height: 8), // Adjusted spacing
              Text(
                "Common Atlas is your guide to exploring the city in a fun and interactive way! Discover hidden gems, complete challenges, and learn more about your surroundings.",
                style: Theme.of(context).textTheme.bodyMedium, // Changed to bodyMedium
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
