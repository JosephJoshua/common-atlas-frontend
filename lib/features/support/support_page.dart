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
                "Your location data is used only while the app is active to show your position on the map, display nearby routes, and track your progress along an active route. We respect your privacy; please see our Data and Privacy section for more details.",
              ),
              _buildFAQItem(
                context,
                "Can I suggest a new route?",
                "We're always excited to hear about new route ideas! Currently, route suggestions can be emailed to routes@commonatlas.dev. We're working on an in-app feature for this!",
              ),
              _buildFAQItem(
                context,
                "What do the different checkpoint game types mean?",
                "Trivia challenges test your knowledge, Photo Challenges ask you to capture a specific scene, and Prop Hunts involve finding a hidden object at the location. Each offers a unique way to interact with your surroundings!",
              ),
              const SizedBox(height: 24), 

              Text("Contact Us", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12), 
              Text(
                "For further assistance, feature requests, or bug reports, please email us at:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4), 
              SelectableText( 
                "support@commonatlas.dev",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12), 
              Text(
                "Or visit our support website:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4), 
              TextButton.icon(
                icon: Icon(Icons.link, color: Theme.of(context).colorScheme.primary), 
                label: Text(
                  "commonatlas.dev/support",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline), 
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
              const SizedBox(height: 24), 

              Text("About Common Atlas", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12), 
              Text("Version: 1.0.0 (Polished MVP)", style: Theme.of(context).textTheme.bodyMedium), // Updated version string
              const SizedBox(height: 8), 
              Text(
                "Common Atlas is your guide to exploring the city in a fun and interactive way! Discover hidden gems, complete challenges, and learn more about your surroundings. Embark on adventures, test your knowledge, and see your city in a new light!", // Slightly expanded description
                style: Theme.of(context).textTheme.bodyMedium, 
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
