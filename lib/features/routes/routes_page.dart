import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/route_model.dart';
import '../../providers/route_provider.dart';
import '../../providers/user_provider.dart';
// import '../active_route/active_route_screen.dart'; // No longer directly navigating here
import 'package:common_atlas_frontend/widgets/app_drawer.dart';
import 'package:common_atlas_frontend/app.dart'; // For MainScreen navigation

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  String _selectedFilter = "All"; // State variable for filter

  @override
  Widget build(BuildContext context) {
    // Access providers
    final routeProv = Provider.of<RouteProvider>(context);
    final userProv = Provider.of<UserProvider>(context);

    // Filter logic
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0), // Increased vertical padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjusted for better spacing
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0), // Adjusted padding
                ),
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
          Expanded(
            child: ListView.builder(
              itemCount: displayedRoutes.length,
              itemBuilder: (context, index) {
                final route = displayedRoutes[index];
                return Card(
                  // margin will be picked from CardTheme if this line is removed, or keep for specific override
                  // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // Adjusted padding
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
                        const SizedBox(height: 16), // Increased spacing before button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            child: const Text("Start Route"),
                            onPressed: () {
                              if (userProv.userProfile.energy >= route.energyCost) {
                                userProv.deductEnergy(route.energyCost);
                                routeProv.setActiveRoute(route.id); 

                                // Navigate to the Home tab (HomeMapPage) on MainScreen
                                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 0)),
                                  (route) => false, // Remove all previous routes, making MainScreen the root
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Not enough energy to start this route!")),
                                );
                              }
                            },
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
