// lib/features/mail/mail_page.dart
import 'package:flutter/material.dart';

class MailPage extends StatelessWidget {
  const MailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mail / Messages")),
      body: ListView(
        padding: const EdgeInsets.all(8.0), // Less padding for list view of messages
        children: <Widget>[
            _buildMailItem(
            context,
            icon: Icons.celebration_outlined,
            title: "Welcome to Common Atlas!",
            subtitle: "We're thrilled to have you. Explore your city like never before!",
            date: "Oct 26",
            isRead: false,
          ),
          _buildMailItem(
            context,
            icon: Icons.route_outlined,
            title: "New Route Added: The Waterfront Wanderer",
            subtitle: "Check out the latest scenic route added to your area!",
            date: "Oct 28",
            isRead: false,
          ),
          _buildMailItem(
            context,
            icon: Icons.battery_charging_full_outlined,
            title: "Energy Refilled!",
            subtitle: "Your daily energy has been refilled. Time for a new adventure!",
            date: "Yesterday",
            isRead: true,
          ),
        ],
      )
    );
  }
}

Widget _buildMailItem(BuildContext context, {required IconData icon, required String title, required String subtitle, required String date, bool isRead = false}) {
  return Card(
    elevation: isRead ? 1.0 : 3.0, // Subtle difference for read/unread
    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: isRead ? BorderSide.none : BorderSide(color: Theme.of(context).colorScheme.primary, width: 0.5) // Highlight unread
    ),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: isRead ? Colors.grey[300] : Theme.of(context).colorScheme.primary.withOpacity(0.2),
        child: Icon(icon, size: 24, color: isRead ? Colors.grey[600] : Theme.of(context).colorScheme.primary),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: isRead ? FontWeight.normal : FontWeight.bold, fontSize: 17)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isRead ? Colors.grey[600] : Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.9)), maxLines: 2, overflow: TextOverflow.ellipsis,),
      trailing: Text(date, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
      isThreeLine: true, // To accommodate longer subtitles
      onTap: () { /* TODO: Mark as read or navigate to message details if any */ },
    ),
  );
}
