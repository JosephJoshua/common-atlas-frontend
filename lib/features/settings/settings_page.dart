import 'package:common_atlas_frontend/features/support/support_page.dart';
import 'package:common_atlas_frontend/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  bool _soundEffectsEnabled = true;

  bool _musicEnabled = false;

  void _showPlaceholderDialog(BuildContext context, String featureName, String message) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(featureName, style: Theme.of(dialogContext).textTheme.headlineSmall),
          content: Text(message, style: Theme.of(dialogContext).textTheme.bodyMedium),
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

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle:
          subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall) : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }

  Widget _buildSettingsSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0).copyWith(top: 20.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: <Widget>[
          _buildSettingsSectionTitle(context, "General"),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: "Help & FAQ",
            subtitle: "Find answers and support",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportPage()));
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: "About Common Atlas",
            subtitle: "App version, licenses, terms of service",
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text("About Common Atlas"),
                      content: const Text(
                        "Version: 1.0.0 (Enhanced MVP)\n\nExplore your world!\n\n(Mock licenses and terms would go here)",
                      ),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
              );
            },
          ),
          Divider(height: 20, thickness: 1, color: Colors.grey[200]),

          _buildSettingsSectionTitle(context, "Preferences"),

          SwitchListTile(
            secondary: Icon(
              Icons.notifications_none_outlined,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
            ),
            title: Text("Enable Notifications", style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              "Receive updates and alerts",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Notifications ${_notificationsEnabled ? 'Enabled' : 'Disabled'}"),
                ),
              );
            },
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.language_outlined,
            title: "Language",
            subtitle: "English (United States)",
            onTap: () {
              _showPlaceholderDialog(
                context,
                "Language Selection",
                "This would show a language picker dialog or page.",
              );
            },
          ),

          SwitchListTile(
            secondary: Icon(
              Icons.music_note_outlined,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
            ),
            title: Text("Music", style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text("Play background music", style: Theme.of(context).textTheme.bodySmall),
            value: _musicEnabled,
            onChanged: (bool value) {
              setState(() {
                _musicEnabled = value;
              });
            },
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),

          SwitchListTile(
            secondary: Icon(
              Icons.volume_up_outlined,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
            ),
            title: Text("Sound Effects", style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              "Play sounds for interactions",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: _soundEffectsEnabled,
            onChanged: (bool value) {
              setState(() {
                _soundEffectsEnabled = value;
              });
            },
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          Divider(height: 20, thickness: 1, color: Colors.grey[200]),

          _buildSettingsSectionTitle(context, "Legal & Information"),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: "Data and Privacy",
            subtitle: "Review our data usage policy",
            onTap: () {
              _showPlaceholderDialog(
                context,
                "Data and Privacy",
                "This would navigate to a page with privacy policy details.",
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.gavel_outlined,
            title: "Terms of Service",
            onTap: () {
              _showPlaceholderDialog(
                context,
                "Terms of Service",
                "This would display the Terms of Service.",
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.description_outlined,
            title: "Open Source Licenses",
            onTap: () {
              _showPlaceholderDialog(
                context,
                "Open Source Licenses",
                "This would display a list of open source licenses.",
              );
            },
          ),
        ],
      ),
    );
  }
}
