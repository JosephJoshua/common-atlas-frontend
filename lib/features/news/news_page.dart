import 'package:flutter/material.dart';
import 'package:common_atlas_frontend/widgets/app_drawer.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  Widget _buildPatchNoteItem(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary), // Make it look like a link
      ),
    );
  }

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
              flex: 3, // Giving more space to the main content
              child: SingleChildScrollView( // Ensures content can scroll if it overflows
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.grey[300],
                        child: Center(child: Icon(Icons.image, size: 50, color: Colors.grey[600])),
                      ),
                    ),
                    const SizedBox(height: 16), // Increased spacing
                    Text(
                      "Featured Article: The Future of Urban Exploration",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5), // Improved line height
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
              child: SingleChildScrollView( // Ensures sidebar can scroll if it overflows
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patch Notes",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildPatchNoteItem(context, "Version 1.0.2 - Sunshine Update!"),
                    _buildPatchNoteItem(context, "Version 1.0.1 - Map Tweaks & Performance Boosts"),
                    _buildPatchNoteItem(context, "Version 1.0.0 - Launch Day Notes & Known Issues"),
                    _buildPatchNoteItem(context, "Alpha 0.9.5 - Pre-launch Fixes"),
                    _buildPatchNoteItem(context, "Alpha 0.9.0 - Major Feature Drop"),
                    const SizedBox(height: 20), // Spacing before next potential section
                     Text(
                      "Community Spotlight",
                       style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildPatchNoteItem(context, "Best Route of the Week"),
                    _buildPatchNoteItem(context, "Interview with a Top Explorer"),

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
