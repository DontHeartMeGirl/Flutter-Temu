import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("登录")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "用户名"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "密码"),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                authController.login(
                  usernameController.text,
                  passwordController.text,
                );
                if (authController.isLoggedIn.value) {
                  Get.offNamed('/home'); // 跳转到首页
                }
              },
              child: Text("登录"),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Get.snackbar("注册提示", "请联系管理员注册用户");
              },
              child: Text("还没有账户？注册"),
            ),
          ],
        ),
      ),
    );
  }
}
