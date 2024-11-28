import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_manager/data_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool loadSampleData = false; // Sample data toggle
  bool enableDarkMode = true; // Example additional setting
  bool notificationsEnabled = false; // Example additional setting

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataNotifier, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E), // Dark background
          appBar: AppBar(
            backgroundColor: const Color(0xFF222244),
            elevation: 0,
            foregroundColor: Colors.white,
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Section: General Settings
              const Text(
                "General",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildToggleOption(
                title: "Load Sample Data",
                subtitle: "Turn on/off sample data for testing purposes",
                value: dataNotifier.isSampleLoaded(),
                icon: Icons.dataset,
                enabled: !(Provider.of<DataProvider>(context, listen: false).sampleLoaded && !Provider.of<DataProvider>(context, listen: false).isSampleLoaded()),
                onChanged: (value) {
                  if (!value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Restart app for changes to take effect.'),
                      ),
                    );
                  }
                  Provider.of<DataProvider>(context, listen: false).toggleIsSample(value: value);
                },
              ),
              const SizedBox(height: 16),
              _buildToggleOption(
                title: "Enable Notifications",
                subtitle: "Receive reminders and updates",
                value: notificationsEnabled,
                icon: Icons.notifications_rounded,
                enabled: false,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildToggleOption(
                title: "Enable Dark Mode",
                subtitle: "Use a dark theme for the app",
                value: enableDarkMode,
                icon: Icons.dark_mode_rounded,
                onChanged: (value) {
                  setState(() {
                    enableDarkMode = value;
                  });
                },
              ),
        
              const SizedBox(height: 24),
              // Section: Data & Privacy
              const Text(
                "Data & Privacy",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                onTap: () {
                  // Handle export data
                  print("Export data clicked");
                },
                tileColor: const Color(0xFF222244),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                leading: const Icon(Icons.upload_file, color: Colors.white),
                title: const Text(
                  "Export Data",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  "Download all your data as a file",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                onTap: () {
                  // Handle delete all data
                  print("Delete all data clicked");
                },
                tileColor: const Color(0xFF222244),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                title: const Text(
                  "Delete All Data",
                  style: TextStyle(color: Colors.redAccent),
                ),
                subtitle: const Text(
                  "Permanently delete all your data",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  /// Helper: Build Toggle Option
  Widget _buildToggleOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    bool enabled = true, // Enable/disable state
  }) {
    return ListTile(
      tileColor: enabled
          ? const Color(0xFF222244)
          : const Color(0xFF1A1A2E).withOpacity(0.6), // Dimmed background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: Icon(
        icon,
        color: enabled ? Colors.white : Colors.grey, // Dimmed icon color
      ),
      title: Text(
        title,
        style: TextStyle(
          color: enabled ? Colors.white : Colors.grey, // Dimmed text color
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: enabled ? Colors.white70 : Colors.grey, // Dimmed text color
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null, // Disabled state for the switch
        activeColor: enabled ? const Color(0xFF4D4DFF) : Colors.grey, // Dimmed switch
        inactiveThumbColor: Colors.white70,
        inactiveTrackColor: Colors.grey,
      ),
    );
  }

}
