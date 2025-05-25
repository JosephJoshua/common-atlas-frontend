import 'package:flutter/material.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final List<String> items = List<String>.generate(100, (i) => "Route ${i}");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pick your route",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.location_pin, size: 32, color: Colors.red),
                      title: Text(items[index], style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text(
                        "Incididunt ut pariatur minim adipisicing sit duis. Aliquip velit et adipisicing mollit velit amet magna ex ullamco ut fugiat. Ea sit mollit anim deserunt est aliquip anim. Sunt tempor mollit mollit anim tempor cupidatat reprehenderit esse proident commodo voluptate fugiat aliquip. Eu id eiusmod commodo labore Lorem voluptate do mollit id magna exercitation voluptate in. Non fugiat eiusmod officia consectetur do. Voluptate quis quis exercitation veniam incididunt laboris deserunt esse deserunt.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_right, color: Theme.of(context).colorScheme.primary),
                        label: Text(
                          "Go now",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ButtonStyle(iconAlignment: IconAlignment.end),
                      ),
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
