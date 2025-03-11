import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSettingItem(context, Icons.logout, '로그아웃', '/logout'),
        _buildSettingItem(context, Icons.pin, '비밀번호 변경', '/change_password'),
        _buildSettingItem(context, Icons.person_off, '회원탈퇴', '/delete_account'),
      ],
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, String route) {
    return Card(
      color: Colors.white12,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.white),
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
