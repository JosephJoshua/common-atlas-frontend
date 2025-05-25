import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';

class UserProvider extends ChangeNotifier {
  UserProfileModel _userProfile;

  UserProvider() : _userProfile = UserProfileModel(points: 50, energy: 100);

  UserProfileModel get userProfile => _userProfile;

  void deductEnergy(int amount) {
    _userProfile = UserProfileModel(
      points: _userProfile.points,
      energy: (_userProfile.energy - amount).clamp(0, 1000), // Assuming max energy is 1000, can be adjusted
    );
    notifyListeners();
  }

  void addPoints(int amount) {
    _userProfile = UserProfileModel(
      points: _userProfile.points + amount,
      energy: _userProfile.energy,
    );
    notifyListeners();
  }

  bool spendPoints(int amount) {
    if (_userProfile.points >= amount) {
      _userProfile = UserProfileModel(
        points: _userProfile.points - amount,
        energy: _userProfile.energy,
      );
      notifyListeners();
      return true;
    }
    return false;
  }
}
