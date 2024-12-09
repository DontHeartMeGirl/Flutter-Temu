import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/db_service.dart';
import '../ui/pages/profile_page.dart';
//注册、登录表单文件
class ProfileDialog extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const ProfileDialog({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isRegistered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,//弹出框的高度为屏幕高度的65%
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Sign in/Join Free",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            if (!isRegistered) _buildRegisterForm() else _buildSignInForm(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
///注册表单
Widget _buildRegisterForm() {
    return Column(
      children: [
        _buildTextField(accountController, "account"),
        _buildTextField(passwordController, "password", isPassword: true),
        _buildTextField(confirmPasswordController, "confirm password",
            isPassword: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (accountController.text.isEmpty ||
                passwordController.text.isEmpty ||
                confirmPasswordController.text.isEmpty) {
              Get.snackbar("Error", "The input box has an empty value",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
            } else if (passwordController.text !=
                confirmPasswordController.text) {
              Get.snackbar("错误", "两次密码输入不一致",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
            } else {
              // 调用 SQLite 注册
              try {
                await dbService.registerUser(
                    accountController.text, passwordController.text);
                setState(() {
                  isRegistered = true;
                });
                // 清空输入框
                accountController.clear();
                passwordController.clear();
                confirmPasswordController.clear();
                Get.snackbar("注册成功", "请登录您的账号",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: Duration(seconds: 1));
              } catch (e) {
                Get.snackbar("注册失败", "账号已存在",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
              }
            }
          },
          child: const Text("Register"),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isRegistered = true;
            });
          },
          child: Text("Sign in", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

/// 构建登录表单
  Widget _buildSignInForm() {
    return Column(
      children: [
        _buildTextField(accountController, "account"),
        _buildTextField(passwordController, "password", isPassword: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (accountController.text.isEmpty ||
                passwordController.text.isEmpty) {
              Get.snackbar("Error", "The input box has an empty value",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white);
            } else {
              final user = await dbService.loginUser(
                  accountController.text, passwordController.text);
              if (user != null) {
                // 保存登录状态并记录当前用户的账号
                await dbService.setLoginStatus(true, account: user['account']);
                widget.onLoginSuccess(); // 通知登录成功
                Get.back(); // 关闭登录对话框
                Get.snackbar("登录成功", "欢迎回来 ${user['account']}",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white);
              } else {
                Get.snackbar("登录失败", "账号或密码错误",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
              }
            }
          },
          child: const Text("Sign in"),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              isRegistered = false; // 切换到注册界面
            });
          },
          child: Text(
            "Back to Register",
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          suffixIcon: isPassword ? const Icon(Icons.visibility_off) : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
