import 'package:flutter/material.dart';
import '../models/reward_model.dart';

class RewardProvider extends ChangeNotifier {
  List<RewardModel> _rewards;

  List<RewardModel> get rewards => _rewards;

  RewardProvider() : _rewards = [] {
    _rewards = [
      RewardModel(
        id: "rw1",
        name: "Free Ice Cream",
        pointCost: 100,
        iconPlaceholder: "icecream", // Placeholder, actual IconData or path would be used
        description: "A delicious free ice cream cone from a participating local vendor.",
      ),
      RewardModel(
        id: "rw2",
        name: "Bike Rental Discount",
        pointCost: 250,
        iconPlaceholder: "directions_bike", // Placeholder
        description: "20% off your next bike rental to explore even further.",
      ),
      RewardModel(
        id: "rw3",
        name: "Museum Ticket Stub",
        pointCost: 150,
        iconPlaceholder: "museum", // Placeholder
        description: "A collectible digital stub for one of Boston's famous museums.",
      ),
    ];
  }

  // Optional: Method to claim a reward if we want to add logic here
  // bool claimReward(String rewardId, UserProvider userProvider) {
  //   try {
  //     RewardModel reward = _rewards.firstWhere((r) => r.id == rewardId);
  //     if (userProvider.spendPoints(reward.pointCost)) {
  //       // Potentially remove reward from list or mark as claimed
  //       // _rewards.removeWhere((r) => r.id == rewardId);
  //       notifyListeners();
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     // Reward not found
  //     return false;
  //   }
  // }
}
