import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/route_model.dart';
import '../../providers/route_provider.dart';
import '../../providers/user_provider.dart';
// import '../active_route/active_route_screen.dart'; // No longer directly navigating here
import 'package:common_atlas_frontend/widgets/app_drawer.dart';
import 'package:common_atlas_frontend/app.dart'; // For MainScreen navigation

/// A page that displays a list of available routes for the user to start.
///
/// It allows filtering routes and shows a special card for any currently active route,
/// providing options to view it on the map or end it.
class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  /// Stores the currently selected filter for the route list (e.g., "All", "Scenic", "Active").
  String _selectedFilter = "All"; 

  @override
  Widget build(BuildContext context) {
    // Access providers for route data, user data, and active route status.
    final routeProv = Provider.of<RouteProvider>(context);
    final userProv = Provider.of<UserProvider>(context);
    final activeRoute = routeProv.activeRoute; // Get the currently active route, if any.

    // Filter the list of all available routes based on the _selectedFilter.
    final allRoutes = routeProv.availableRoutes;
    final displayedRoutes = allRoutes.where((route) {
      if (_selectedFilter == "All") return true;
      if (_selectedFilter == "Scenic") return route.type == RouteType.scenic;
      if (_selectedFilter == "Active") return route.type == RouteType.active;
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Routes"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Section to display the currently active route, if one exists.
          // This card provides quick access to view the route on the map or end it.
          if (activeRoute != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 3.0,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("Distance: ${activeRoute.distance}, Difficulty: ${activeRoute.difficulty}", style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.map_outlined, color: Theme.of(context).colorScheme.primary),
                            label: Text("View on Map", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                            onPressed: () {
                              // Navigate to the HomeMapPage (main map screen).
                              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 0)),
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          // Button to end the currently active route.
                          // Clears the active route from RouteProvider and shows a confirmation SnackBar.
                          ElevatedButton.icon(
                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: const Text("End Route"),
                            onPressed: () {
                              routeProvider.clearActiveRoute();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${activeRoute.name} ended.")),
                              );
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

          // Filter chips for route types.
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
                    color: _selectedFilter == "All" ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0), 
                ),
                // Similar ChoiceChip widgets for "Scenic" and "Active" filters...
                ChoiceChip(
                  label: const Text("Scenic"),
                  selected: _selectedFilter == "Scenic",
                  onSelected: (isSelected) {
                    if (isSelected) setState(() => _selectedFilter = "Scenic");
                  },
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: _selectedFilter == "Scenic" ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
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
                    color: _selectedFilter == "Active" ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                ),
              ],
            ),
          ),
          // List of available routes, displayed in Cards.
          Expanded(
            child: ListView.builder(
              itemCount: displayedRoutes.length,
              itemBuilder: (context, index) {
                final route = displayedRoutes[index];
                // Determine if the current route in the list is the one that's active globally.
                final bool isThisRouteActive = activeRoute?.id == route.id;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.name, 
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text("Type: ${route.type.toString().split('.').last}", style: Theme.of(context).textTheme.bodyMedium),
                        Text("Distance: ${route.distance}", style: Theme.of(context).textTheme.bodyMedium),
                        Text("Difficulty: ${route.difficulty}", style: Theme.of(context).textTheme.bodyMedium),
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
                            // Button text and action change based on whether this route is the active one.
                            // If active, it navigates to the map to view it.
                            // If not active, it allows the user to start the route.
                            child: Text(isThisRouteActive ? "View Active Route" : "Start Route"),
                            onPressed: () {
                              if (isThisRouteActive) {
                                // Navigate to HomeMapPage if this route is already active.
                                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 0)),
                                  (route) => false,
                                );
                              } else {
                                // Logic to start a new route.
                                // Checks for sufficient energy before proceeding.
                                if (userProv.userProfile.energy >= route.energyCost) {
                                  userProv.deductEnergy(route.energyCost);
                                  routeProvider.setActiveRoute(route.id);
                                  // Navigate to HomeMapPage after starting the route.
                                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 0)),
                                    (route) => false,
                                  );
                                } else {
                                  // Show error if user lacks energy.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Not enough energy to start this route!")),
                                  );
                                }
                              }
                            },
                            // Style the button differently if it's for the currently active route.
                            style: isThisRouteActive 
                                ? ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary) 
                                : null, // Inherits from global ElevatedButtonTheme otherwise
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
