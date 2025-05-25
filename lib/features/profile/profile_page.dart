import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
// import '../progress/progress_page.dart'; // No longer directly used
import '../../app.dart'; // For MainScreen navigation for Store & Progress
import 'package:common_atlas_frontend/widgets/app_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildProfileButton(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  void _showPlaceholderDialog(BuildContext context, String featureName) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(featureName),
          content: Text("This feature ($featureName) is not yet implemented in the prototype."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: "Settings",
            onPressed: () {
              _showPlaceholderDialog(context, "Settings");
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Profile Info Section
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                child: Icon(Icons.person_outline, size: 50, color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              const SizedBox(height: 12),
              Text(
                "Explorer Extraordinaire", // Placeholder name
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // User Stats Section
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Energy", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
                          const SizedBox(height: 4),
                          Text("${userProvider.userProfile.energy}", style: Theme.of(context).textTheme.headlineSmall),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Points", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
                          const SizedBox(height: 4),
                          Text("${userProvider.userProfile.points}", style: Theme.of(context).textTheme.headlineSmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Navigation Buttons
              _buildProfileButton(
                context,
                icon: Icons.show_chart_outlined,
                title: "Progress Tracker",
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 1)), // Progress tab is index 1
                    (route) => false,
                  );
                },
              ),
              _buildProfileButton(
                context,
                icon: Icons.card_giftcard_outlined,
                title: "Free Rewards",
                onTap: () {
                  // Navigate to StorePage (index 2 in MainScreen)
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 2)),
                    (route) => false,
                  );
                },
              ),
              _buildProfileButton(
                context,
                icon: Icons.palette_outlined, // Changed from Icons.brush
                title: "Customization",
                onTap: () {
                  _showPlaceholderDialog(context, "Customization");
                },
              ),
              const SizedBox(height: 30),

              // Optional Logout Button
              ElevatedButton.icon(
                icon: const Icon(Icons.logout_outlined),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  _showPlaceholderDialog(context, "Logout");
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
