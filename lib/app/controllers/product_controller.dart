import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final cart = <Map<String, dynamic>>[].obs; // 购物车商品列表
  bool isSnackbarShown = false; // 防止重复显示Snackbar

  // 添加商品到购物车，如果已经有该商品，则增加数量
  void addToCart(Map<String, dynamic> product, int quantity) {
    // 查找购物车中是否已有此商品
    final existingProduct = cart.firstWhere(
      (item) => item['name'] == product['name'],
      orElse: () => {}, // 返回一个空的 Map，确保返回一个合法的 Map 类型
    );

    if (existingProduct.isNotEmpty) {
      // 如果商品已经存在，更新商品的数量
      existingProduct['quantity'] += quantity;
    } else {
      // 如果商品不存在，添加商品并设置数量
      final cartProduct = {...product, 'quantity': quantity};
      cart.add(cartProduct); // 将商品添加到购物车
    }

    // 弹出成功的Snackbar
    Get.snackbar(
      "Added to Shopping Cart Successfully", "",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 1),
      snackPosition: SnackPosition.TOP, //将 Snackbar 放置在顶部
      maxWidth:
          MediaQuery.of(Get.context!).size.width, // 使用 Get.context 获取当前 context
      messageText: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "${product['name']}\n数量: $quantity", // 商品名称和数量分行显示
            maxLines: 1, // 商品名称限制为一行
            overflow: TextOverflow.ellipsis, // 超出部分使用省略号显示
            style: TextStyle(fontSize: 16, color: Colors.white), // 设置字体样式
          ),
          Text(
            "Quantity : $quantity , Successfully added to cart", // 商品名称和数量分行显示
            style: TextStyle(fontSize: 14, color: Colors.white), // 设置字体样式
          ),
        ],
      ),
    );
  }

  // 重置Snackbar状态
  void resetSnackbar() {
    isSnackbarShown = false;
  }

  // 购物车移除商品
  void removeFromCart(int index) {
    cart.removeAt(index);
    Get.snackbar("移除成功", "商品已从购物车移除");
  }
}
