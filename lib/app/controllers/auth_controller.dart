import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs; // 观察用户登录状态

  void login(String username, String password) {
    if (username == "admin" && password == "123456") {
      isLoggedIn.value = true;
      Get.snackbar("登录成功", "欢迎回来 $username");
    } else {
      Get.snackbar("登录失败", "用户名或密码错误");
    }
  }

  void logout() {
    isLoggedIn.value = false;
    Get.snackbar("已退出", "您已成功退出登录");
  }
}
