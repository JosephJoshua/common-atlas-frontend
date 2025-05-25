import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/route_model.dart';
import '../../providers/route_provider.dart';
import '../../providers/user_provider.dart';
import '../active_route/active_route_screen.dart'; // Updated import
import 'package:common_atlas_frontend/widgets/app_drawer.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ChoiceChip(
                  label: const Text("All"),
                  selected: _selectedFilter == "All",
                  onSelected: (isSelected) {
                    if (isSelected) {
                      setState(() {
                        _selectedFilter = "All";
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text("Scenic"),
                  selected: _selectedFilter == "Scenic",
                  onSelected: (isSelected) {
                    if (isSelected) {
                      setState(() {
                        _selectedFilter = "Scenic";
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text("Active"),
                  selected: _selectedFilter == "Active",
                  onSelected: (isSelected) {
                    if (isSelected) {
                      setState(() {
                        _selectedFilter = "Active";
                      });
                    }
                  },
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
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(route.name, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text("Type: ${route.type.toString().split('.').last}"),
                        Text("Distance: ${route.distance}"),
                        Text("Difficulty: ${route.difficulty}"),
                        Text("Energy Cost: ${route.energyCost}"),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            child: const Text("Start Route"),
                            onPressed: () {
                              if (userProv.userProfile.energy >= route.energyCost) {
                                userProv.deductEnergy(route.energyCost);
                                routeProv.setActiveRoute(route.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ActiveRouteScreen(),
                                  ),
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
