import 'package:common_atlas_frontend/app.dart';
import 'package:common_atlas_frontend/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/route_model.dart';
import '../../providers/route_provider.dart';
import '../../providers/user_provider.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  String _selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final routeProv = Provider.of<RouteProvider>(context);
    final userProv = Provider.of<UserProvider>(context);
    final activeRoute = routeProv.activeRoute;

    final allRoutes = routeProv.availableRoutes;
    final displayedRoutes =
        allRoutes.where((route) {
          if (_selectedFilter == "All") return true;
          if (_selectedFilter == "Scenic") return route.type == RouteType.scenic;
          if (_selectedFilter == "Active") return route.type == RouteType.active;
          return false;
        }).toList();

    return Scaffold(
      drawer: const AppDrawer(),
      body: Column(
        children: [
          if (activeRoute != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 3.0,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Currently Active Route:",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activeRoute.name,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Distance: ${activeRoute.distance}, Difficulty: ${activeRoute.difficulty}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            icon: Icon(
                              Icons.map_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            label: Text(
                              "View on Map",
                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(initialPageIndex: 0),
                                ),
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),

                          ElevatedButton.icon(
                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: const Text("End Route"),
                            onPressed: () {
                              routeProv.clearActiveRoute();
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text("${activeRoute.name} ended.")));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.8),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            const SizedBox(height: 8),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ChoiceChip(
                  label: const Text("All"),
                  selected: _selectedFilter == "All",
                  onSelected: (isSelected) {
                    if (isSelected) setState(() => _selectedFilter = "All");
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color:
                        _selectedFilter == "All"
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                ),

                ChoiceChip(
                  label: const Text("Scenic"),
                  selected: _selectedFilter == "Scenic",
                  onSelected: (isSelected) {
                    if (isSelected) setState(() => _selectedFilter = "Scenic");
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color:
                        _selectedFilter == "Scenic"
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                ),
                ChoiceChip(
                  label: const Text("Active"),
                  selected: _selectedFilter == "Active",
                  onSelected: (isSelected) {
                    if (isSelected) setState(() => _selectedFilter = "Active");
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color:
                        _selectedFilter == "Active"
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: displayedRoutes.length,
              itemBuilder: (context, index) {
                final route = displayedRoutes[index];

                final bool isThisRouteActive = activeRoute?.id == route.id;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Type: ${route.type.toString().split('.').last}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "Distance: ${route.distance}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "Difficulty: ${route.difficulty}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Energy Cost: ${route.energyCost}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isThisRouteActive) {
                                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(initialPageIndex: 0),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                if (userProv.userProfile.energy >= route.energyCost) {
                                  userProv.deductEnergy(route.energyCost);
                                  routeProv.setActiveRoute(route.id);

                                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const MainScreen(initialPageIndex: 0),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Not enough energy to start this route!"),
                                    ),
                                  );
                                }
                              }
                            },

                            style:
                                isThisRouteActive
                                    ? ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                    )
                                    : null,
                            child: Text(isThisRouteActive ? "View Active Route" : "Start Route"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
