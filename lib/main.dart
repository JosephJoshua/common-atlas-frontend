import 'package:common_atlas_frontend/app.dart';
import 'package:common_atlas_frontend/providers/reward_provider.dart';
import 'package:common_atlas_frontend/providers/route_provider.dart';
import 'package:common_atlas_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RouteProvider()),
        ChangeNotifierProvider(create: (_) => RewardProvider()),
      ],
      child: const CommonAtlasApp(),
    ),
  );
}
