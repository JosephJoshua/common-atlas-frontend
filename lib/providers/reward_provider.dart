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
        iconPlaceholder: "icecream",
        description: "A delicious free ice cream cone from a participating local vendor.",
      ),
      RewardModel(
        id: "rw2",
        name: "Bike Rental Discount",
        pointCost: 250,
        iconPlaceholder: "directions_bike",
        description: "20% off your next bike rental to explore even further.",
      ),
      RewardModel(
        id: "rw3",
        name: "Museum Ticket Stub",
        pointCost: 150,
        iconPlaceholder: "museum",
        description: "A collectible digital stub for one of Boston's famous museums.",
      ),
    ];
  }
}
