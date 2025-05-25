import 'package:flutter/material.dart';
import 'package:common_atlas_frontend/widgets/app_drawer.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NEWS"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Content Area (Left)
            Expanded(
              flex: 2, // Adjusted flex factor
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Featured Article 1
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(child: Icon(Icons.image_outlined, size: 50, color: Colors.grey[500])),
                      ),
                    ),
                    const SizedBox(height: 12), // Adjusted spacing
                    Text(
                      "Summer Exploration Challenge Announced!",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Get ready to discover hidden gems in your city with our new Summer Exploration Challenge! Special rewards and badges await those who complete all featured routes...",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),

                    // Featured Article 2 (Optional)
                     AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[350], // Slightly different color for visual distinction
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(child: Icon(Icons.developer_mode_outlined, size: 50, color: Colors.grey[600])),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Developer Insights: The Making of the Map",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Go behind the scenes with our dev team as they discuss the challenges and triumphs of building the interactive map features you love. Learn about the technology stack and future plans for map enhancements.",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Sidebar Area (Right)
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patch Notes",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildSidebarLinkItem(context, "Version 1.1.0: Map Polish & UI Enhancements", "Improved map loading times and updated several UI elements for a cleaner look."),
                    _buildSidebarLinkItem(context, "Version 1.0.5: New Routes in Downtown", "Added three exciting new routes for exploring the downtown area. Check them out!"),
                    _buildSidebarLinkItem(context, "Version 1.0.2: Minigame Fixes", "Addressed minor bugs in Trivia and Photo Challenge minigames."),
                    const SizedBox(height: 24),
                     Text(
                      "Community Spotlight",
                       style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildSidebarLinkItem(context, "Route of the Week: 'Parkside Loop' by Explorer123", "Discover this amazing user-created route!"),
                    _buildSidebarLinkItem(context, "Photo Contest Winners Announced!", "See the stunning winning entries from our latest photo challenge."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// New helper method for sidebar items
Widget _buildSidebarLinkItem(BuildContext context, String title, String? description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
        if (description != null) ...[
          const SizedBox(height: 2),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
        ]
      ],
    ),
  );
}
