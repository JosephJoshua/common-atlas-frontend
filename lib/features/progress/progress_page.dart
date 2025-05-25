// lib/features/progress/progress_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
// import '../../providers/route_provider.dart'; // Optional, not used in this specific layout
import 'package:common_atlas_frontend/widgets/app_drawer.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PROGRESS"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // Main Map Area
          Container(
            color: Colors.lightBlue[100], // Light blue to simulate a map background
            constraints: const BoxConstraints.expand(),
            child: Center(
              child: Text(
                "MAP",
                style: TextStyle(
                  fontSize: 150, // Larger for background effect
                  color: Colors.black.withOpacity(0.08),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Mock Completed Routes/Areas
          Positioned( // Mock Route 1: Blue Line
            top: 100,
            left: 50,
            child: Container(width: 150, height: 6, color: Colors.blueAccent.withOpacity(0.7)),
          ),
          Positioned( // Mock Route 2: Another Blue Line
            top: 150,
            left: 100,
            child: Transform.rotate(
              angle: 0.4, // Slight angle
              child: Container(width: 120, height: 6, color: Colors.blueAccent.withOpacity(0.7)),
            ),
          ),
          Positioned( // Mock Area "Cambridge"
            top: 180,
            left: 60,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.4),
                border: Border.all(color: Colors.orangeAccent.shade700, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Cambridge\n(Explored 65%)",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
           Positioned( // Mock Area "Downtown"
            top: 300,
            left: 180,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.4),
                border: Border.all(color: Colors.green.shade700, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Downtown\n(Explored 80%)",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),


          // Legend Area
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12.0), // Match CardTheme
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Legend", 
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.timeline, color: Colors.blueAccent.shade700, size: 20),
                    const SizedBox(width: 8),
                    Text("Completed Route", style: Theme.of(context).textTheme.bodyMedium)
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.7), border: Border.all(color: Colors.orangeAccent.shade700))),
                    const SizedBox(width: 8),
                    Text("Explored Area", style: Theme.of(context).textTheme.bodyMedium)
                  ]),
                   const SizedBox(height: 4),
                  Row(children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.7), border: Border.all(color: Colors.green.shade700))),
                    const SizedBox(width: 8),
                    Text("Well Explored Area", style: Theme.of(context).textTheme.bodyMedium)
                  ]),
                ],
              ),
            ),
          ),

          // Stats Display Area
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12.0), // Match CardTheme
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Points: ${userProvider.userProfile.points}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Map Completion: 35% (mock)",
                     style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
