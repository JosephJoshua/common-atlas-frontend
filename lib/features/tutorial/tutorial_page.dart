import 'package:common_atlas_frontend/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutorial"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            "How to Use Common Atlas",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildTutorialItem(
            context,
            icon: Icons.map_outlined,
            title: "Finding Your First Route",
            subtitle:
                "Learn how to browse and select scenic or active routes to begin your adventure.",
          ),
          _buildTutorialItem(
            context,
            icon: Icons.gamepad_outlined,
            title: "Checkpoints & Minigames",
            subtitle: "Discover how to interact with checkpoints and complete fun minigames.",
          ),
          _buildTutorialItem(
            context,
            icon: Icons.star_border_outlined,
            title: "Earning Points & Using Rewards",
            subtitle:
                "Complete routes to earn points and redeem them for cool rewards in the Store.",
          ),
          _buildTutorialItem(
            context,
            icon: Icons.show_chart_outlined,
            title: "Tracking Your Progress",
            subtitle: "See your completed routes and achievements on the Progress page.",
          ),
        ],
      ),
    );
  }
}

Widget _buildTutorialItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      leading: Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
  );
}
