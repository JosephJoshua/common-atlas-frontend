import 'package:flutter/material.dart';
import 'package:common_atlas_frontend/widgets/app_drawer.dart'; // For AppDrawer
import 'package:common_atlas_frontend/features/support/support_page.dart'; // For SupportPage navigation example

/// A page that allows users to configure various application settings.
///
/// Includes options for general help, preferences like notifications and audio,
/// and legal/information sections.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State variables for managing the on/off status of preference toggles.
  /// Whether notifications are currently enabled.
  bool _notificationsEnabled = true;
  /// Whether sound effects are currently enabled.
  bool _soundEffectsEnabled = true;
  /// Whether background music is currently enabled.
  bool _musicEnabled = false;

  /// Helper method to display a generic placeholder dialog for features not yet implemented.
  ///
  /// [context] The build context for showing the dialog.
  /// [featureName] The name of the feature to display in the dialog title.
  /// [message] The message to display in the dialog content.
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

  /// Builds a styled [ListTile] for settings items that navigate or perform an action.
  ///
  /// [context] The build context.
  /// [icon] The leading icon for the tile.
  /// [title] The main title text for the tile.
  /// [subtitle] Optional subtitle text displayed below the title.
  /// [onTap] The callback function executed when the tile is tapped.
  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.bodySmall) : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }

  /// Builds a styled section title for grouping settings items.
  ///
  /// [context] The build context.
  /// [title] The text to display as the section title.
  Widget _buildSettingsSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0).copyWith(top:20.0),
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
          }
        ),
      ),
      drawer: const AppDrawer(), 
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: <Widget>[
          // General settings section.
          _buildSettingsSectionTitle(context, "General"),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: "Help & FAQ",
            subtitle: "Find answers and support",
            onTap: () {
              // Navigates to the SupportPage when tapped.
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportPage()));
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: "About Common Atlas",
            subtitle: "App version, licenses, terms of service",
            onTap: () {
              // Shows an AlertDialog with mock "About" information.
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("About Common Atlas"),
                  content: const Text("Version: 1.0.0 (Enhanced MVP)\n\nExplore your world!\n\n(Mock licenses and terms would go here)"),
                  actions: [TextButton(child: const Text("OK"), onPressed: () => Navigator.of(ctx).pop())],
                ),
              );
            },
          ),
          Divider(height: 20, thickness: 1, color: Colors.grey[200]),

          // Preferences section with toggleable settings.
          _buildSettingsSectionTitle(context, "Preferences"),
          // SwitchListTile for enabling/disabling notifications.
          // Updates the `_notificationsEnabled` state and shows a SnackBar.
          SwitchListTile(
            secondary: Icon(Icons.notifications_none_outlined, color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
            title: Text("Enable Notifications", style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text("Receive updates and alerts", style: Theme.of(context).textTheme.bodySmall),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() { _notificationsEnabled = value; });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Notifications ${_notificationsEnabled ? 'Enabled' : 'Disabled'}")));
            },
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.language_outlined,
            title: "Language",
            subtitle: "English (United States)", // Mock current language display.
            onTap: () {
              // Shows a placeholder dialog for language selection.
              _showPlaceholderDialog(context, "Language Selection", "This would show a language picker dialog or page.");
            },
          ),
          // SwitchListTile for enabling/disabling background music.
          // Updates the `_musicEnabled` state.
          SwitchListTile(
            secondary: Icon(Icons.music_note_outlined, color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
            title: Text("Music", style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text("Play background music", style: Theme.of(context).textTheme.bodySmall), 
            value: _musicEnabled,
            onChanged: (bool value) { setState(() { _musicEnabled = value; }); },
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          // SwitchListTile for enabling/disabling sound effects.
          // Updates the `_soundEffectsEnabled` state.
          SwitchListTile(
            secondary: Icon(Icons.volume_up_outlined, color: Theme.of(context).iconTheme.color?.withOpacity(0.7)),
            title: Text("Sound Effects", style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text("Play sounds for interactions", style: Theme.of(context).textTheme.bodySmall), 
            value: _soundEffectsEnabled,
            onChanged: (bool value) { setState(() { _soundEffectsEnabled = value; }); },
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          ),
          Divider(height: 20, thickness: 1, color: Colors.grey[200]),

          // Legal & Information section.
          _buildSettingsSectionTitle(context, "Legal & Information"),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: "Data and Privacy",
            subtitle: "Review our data usage policy",
            onTap: () {
              // Shows a placeholder dialog for data and privacy policy.
              _showPlaceholderDialog(context, "Data and Privacy", "This would navigate to a page with privacy policy details.");
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.gavel_outlined, 
            title: "Terms of Service",
            onTap: () {
               // Shows a placeholder dialog for Terms of Service.
               _showPlaceholderDialog(context, "Terms of Service", "This would display the Terms of Service.");
            }
          ),
          _buildSettingsTile(
            context,
            icon: Icons.description_outlined, 
            title: "Open Source Licenses",
            onTap: () {
               // Shows a placeholder dialog for Open Source Licenses.
               _showPlaceholderDialog(context, "Open Source Licenses", "This would display a list of open source licenses.");
            }
          ),
        ],
      ),
    );
  }
}
