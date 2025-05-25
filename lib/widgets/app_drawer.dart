import 'package:flutter/material.dart';
import '../features/tutorial/tutorial_page.dart';
import '../features/mail/mail_page.dart';
import '../features/news/news_page.dart';
import '../features/support/support_page.dart';
import '../features/settings/settings_page.dart'; // Added for SettingsPage
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
            child: Align( // Align text to bottom left with padding
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0, left: 4.0), // Adjust padding as needed
                child: Text(
                  'Common Atlas Menu',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white, // Explicitly white for onPrimary
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
            title: Text('Home (Map)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context); // Close drawer first
              Provider.of<RouteProvider>(context, listen: false).clearActiveRoute();
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainScreen(initialPageIndex: 0)),
                (route) => false,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.article_outlined, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
            title: Text('News', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.support_agent_outlined, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
            title: Text('Support', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.school_outlined, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
            title: Text('Tutorial', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TutorialPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.mail_outline, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
            title: Text('Mail', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MailPage()));
            },
          ),
          Divider(thickness: 1, color: Colors.grey[200]), // Styled Divider
          ListTile(
            leading: Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
            title: Text('Settings', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
            title: Text('Log Out', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
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
