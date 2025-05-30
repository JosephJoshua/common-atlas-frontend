import 'package:common_atlas_frontend/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/reward_provider.dart';
import '../../providers/user_provider.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  IconData _getIconForReward(String iconPlaceholder) {
    switch (iconPlaceholder) {
      case "icecream":
        return Icons.icecream_outlined;
      case "directions_bike":
        return Icons.directions_bike_outlined;
      case "museum":
        return Icons.museum_outlined;
      default:
        return Icons.star_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final rewardProvider = Provider.of<RewardProvider>(context);
    final currentPoints = userProvider.userProfile.points;
    final rewards = rewardProvider.rewards;

    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Plans",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Paid Plan", style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(
                                "Unlock exclusive routes and features.",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(onPressed: () {}, child: const Text("View Details")),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Premium Plan", style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(
                                "All benefits, plus early access & support.",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(onPressed: () {}, child: const Text("View Details")),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                Text(
                  "Points Store",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text("Your Points: $currentPoints", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: Icon(Icons.filter_list, color: Theme.of(context).colorScheme.primary),
                    label: Text(
                      "Filter",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      print("Filter button tapped");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Filter functionality not yet implemented.")),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: rewards.length,
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    bool canRedeem = currentPoints >= reward.pointCost;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary.withValues(alpha: 0.15),
                              child: Icon(
                                _getIconForReward(reward.iconPlaceholder),
                                size: 30,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              reward.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Cost: ${reward.pointCost} Points",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    canRedeem
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey[400],
                              ),
                              onPressed:
                                  canRedeem
                                      ? () {
                                        if (userProvider.spendPoints(reward.pointCost)) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "${reward.name} redeemed successfully!",
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Not enough points to redeem this reward.",
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                      : null,
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
      ),
    );
  }
}
