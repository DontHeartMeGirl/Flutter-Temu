import 'package:flutter/material.dart';
//背景文字颜色
class ProfileBanner extends StatelessWidget {
  const ProfileBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.amber[100],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Free shipping | Price adjustment within 30 days",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.green[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
