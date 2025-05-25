import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/reward_provider.dart';
import '../../models/reward_model.dart';
import 'package:common_atlas_frontend/widgets/app_drawer.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  // Helper method to map icon strings to IconData
  IconData _getIconForReward(String iconPlaceholder) {
    switch (iconPlaceholder) {
      case "icecream":
        return Icons.icecream_outlined;
      case "directions_bike":
        return Icons.directions_bike_outlined;
      case "museum":
        return Icons.museum_outlined;
      default:
        return Icons.star_outline; // Default placeholder
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final rewardProvider = Provider.of<RewardProvider>(context);
    final currentPoints = userProvider.userProfile.points;
    final rewards = rewardProvider.rewards;

    return Scaffold(
      appBar: AppBar(
        title: const Text("STORE"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: SafeArea( // Added SafeArea
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plans Section (Visual Placeholder)
              Text("Plans", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12), // Adjusted spacing
              Row(
                children: [
                  Expanded(
                    child: Card(
                      // elevation will be picked from CardTheme
                      child: Padding(
                        padding: const EdgeInsets.all(16.0), // Increased padding for better internal spacing
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Paid Plan", style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text("Unlock exclusive routes and features.", style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            ElevatedButton(onPressed: () {}, child: const Text("View Details")),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // Adjusted spacing
                  Expanded(
                    child: Card(
                      // elevation will be picked from CardTheme
                      child: Padding(
                        padding: const EdgeInsets.all(16.0), // Increased padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Premium Plan", style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text("All benefits, plus early access & support.", style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            ElevatedButton(onPressed: () {}, child: const Text("View Details")),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32), // Increased spacing

              // Points Section
              Text("Points Store", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12), // Adjusted spacing
              Text("Your Points: $currentPoints", style: Theme.of(context).textTheme.titleMedium), // Removed primary color, will inherit
              const SizedBox(height: 8), // Adjusted spacing
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: Icon(Icons.filter_list, color: Theme.of(context).colorScheme.primary), // Apply primary color
                  label: Text("Filter", style: TextStyle(color: Theme.of(context).colorScheme.primary)), // Apply primary color
                  onPressed: () {
                    // TODO: Implement Filter Rewards functionality
                    print("Filter button tapped");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Filter functionality not yet implemented.")),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12), // Adjusted spacing

              // Rewards Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, // Adjusted for more content and padding
                  crossAxisSpacing: 16, // Increased spacing
                  mainAxisSpacing: 16,  // Increased spacing
                ),
                itemCount: rewards.length,
                itemBuilder: (context, index) {
                  final reward = rewards[index];
                  bool canRedeem = currentPoints >= reward.pointCost;
                  return Card(
                    // elevation will be picked from CardTheme
                    child: Padding(
                      padding: const EdgeInsets.all(12.0), // Adjusted padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adjusted for better spacing
                        children: [
                          CircleAvatar(
                            radius: 35, // Slightly larger
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.15), // Adjusted opacity
                            child: Icon(
                              _getIconForReward(reward.iconPlaceholder),
                              size: 30, // Adjusted icon size
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reward.name, 
                            textAlign: TextAlign.center, 
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16), // Updated style
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Cost: ${reward.pointCost} Points", 
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8), // Added spacing before button
                          ElevatedButton(
                            // Button style will be inherited from ElevatedButtonTheme
                            // Specific style for disabled state can be added if needed
                            style: ElevatedButton.styleFrom(
                               backgroundColor: canRedeem ? Theme.of(context).colorScheme.primary : Colors.grey[400],
                            ),
                            onPressed: canRedeem ? () {
                              if (userProvider.spendPoints(reward.pointCost)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${reward.name} redeemed successfully!")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Not enough points to redeem this reward.")),
                                );
                              }
                            } : null, 
                            child: const Text("Redeem"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
