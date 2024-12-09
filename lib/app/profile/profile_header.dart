import 'package:flutter/material.dart';
//ListTile 用户信息显示文件
class ProfileHeader extends StatelessWidget {
  final String account;
  final String initial;

  const ProfileHeader({Key? key, required this.account, required this.initial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(initial),
        ),
        title: Text(account, style: const TextStyle(fontSize: 18)),
        trailing: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Customer support is not implemented yet.")),
            );
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.support_agent, size: 24, color: Colors.black),
              SizedBox(height: 4),
              Text("Support", style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
