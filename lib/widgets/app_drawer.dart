import 'package:flutter/material.dart';
import '../features/tutorial/tutorial_page.dart';
import '../features/mail/mail_page.dart';
import '../features/news/news_page.dart';
import '../features/support/support_page.dart';
import '../app.dart'; // Required for MainScreen for navigation
import 'package:provider/provider.dart'; // Added for RouteProvider
import '../providers/route_provider.dart'; // Added for RouteProvider

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showPlaceholderDialog(BuildContext context, String featureName) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(featureName),
          content: Text("This feature ($featureName) is not yet implemented in the prototype."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Text(
              'Common Atlas Menu',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, // Use onPrimary for contrast
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home (Routes)'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Clear active route if one exists, as we are going to the main route list
              Provider.of<RouteProvider>(context, listen: false).clearActiveRoute();
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 0)),
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('News'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: const Text('Support'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Tutorial'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TutorialPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Mail'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MailPage()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _showPlaceholderDialog(context, "Settings");
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              _showPlaceholderDialog(context, "Log Out");
            },
          ),
        ],
      ),
    );
  }
}
