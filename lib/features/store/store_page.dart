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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plans Section (Visual Placeholder)
              Text("Plans", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Paid Plan", style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 5),
                            Text("Unlock exclusive routes and features.", style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 10),
                            ElevatedButton(onPressed: () {}, child: const Text("View Details")),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Premium Plan", style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 5),
                            Text("All benefits, plus early access & support.", style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 10),
                            ElevatedButton(onPressed: () {}, child: const Text("View Details")),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Points Section
              Text("Points Store", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 10),
              Text("Your Points: $currentPoints", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filter"),
                  onPressed: () {
                    // TODO: Implement Filter Rewards functionality
                    print("Filter button tapped");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Filter functionality not yet implemented.")),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Rewards Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85, // Adjusted for more content
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: rewards.length,
                itemBuilder: (context, index) {
                  final reward = rewards[index];
                  bool canRedeem = currentPoints >= reward.pointCost;
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                            child: Icon(
                              _getIconForReward(reward.iconPlaceholder),
                              size: 30,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(reward.name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 4),
                          Text("Cost: ${reward.pointCost} Points", style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canRedeem ? Theme.of(context).colorScheme.primary : Colors.grey,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            onPressed: canRedeem ? () {
                              if (userProvider.spendPoints(reward.pointCost)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${reward.name} redeemed successfully!")),
                                );
                              } else {
                                // This case should ideally not be reached if button is disabled,
                                // but kept as a fallback.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Not enough points to redeem this reward.")),
                                );
                              }
                            } : null, // Disable button if not enough points
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
