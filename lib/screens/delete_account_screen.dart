import 'package:flutter/material.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSettingItem(context,  '회원 탈퇴 유의사항', '/logout'),
      ],
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, String route) {
    return Card(
      color: Colors.white12,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontSize: 18, color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white70),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
