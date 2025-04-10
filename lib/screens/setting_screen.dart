import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSettingItem(Icons.notifications, '알림 설정'),
        _buildSettingItem(Icons.dark_mode, '테마 변경'),
        _buildSettingItem(Icons.info, '앱 정보'),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title) {
    return Card(
      color: Colors.white12,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(title,
            style: const TextStyle(fontSize: 18, color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {},
      ),
    );
  }
}
