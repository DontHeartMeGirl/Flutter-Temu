import 'package:flutter/material.dart';
import 'package:flutter_final_exam/app/data/services/db_service.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../pages/home_page.dart';

class CartItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final int index;

  const CartItem({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 减少卡片间距
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // 圆角
      ),
      elevation: 6, // 提高阴影效果，使卡片更加立体
      shadowColor: Colors.grey, // 调整阴影颜色
      child: ListTile(
        leading: Image.network(
          product['image'][0],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Row(
          children: [
            // 商品名称部分
            Expanded(
              child: Text(
                product['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1, // 限制商品名称为一行
                overflow: TextOverflow.ellipsis, // 超出部分显示省略号
              ),
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 商品价格
            Expanded(
              child: Text(
                "Price: \$${product['price2']}",
                style: TextStyle(color: Colors.orange),
              ),
            ),
            // 商品数量
            Expanded(
              child: Text(
                "Quantity: ${product['quantity']}",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            // 从购物车移除商品
            productController.cart.removeAt(index);
          },
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cart"),
      ),
      body: Column(
        children: [
          Container(
            width: 320, // 宽
            height: 40, // 高
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(8)),

            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: Color.fromARGB(255, 49, 144, 52),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "Free shipping from some providers",
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  )
                ],
              ),
            ),
          ),
          // 显示购物车为空的提示或购物车内容
          Obx(() {
            if (productController.cart.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Your cart is empty!",
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(HomePage()); // 跳转到主页
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(120, 40)),
                      child: const Text(
                        "START SHOPPING",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            }

            // 合并购物车中相同商品
            var cartItems = <Map<String, dynamic>>[];

            for (var product in productController.cart) {
              var existingProduct = cartItems.firstWhere(
                (item) => item['name'] == product['name'],
                orElse: () => {},
              );

              if (existingProduct.isEmpty) {
                // 如果商品不存在，添加新的商品
                cartItems.add(product);
              } else {
                // 如果商品已存在，更新数量
                existingProduct['quantity'] += product['quantity'];
              }
            }

            return Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems[index];
                  return CartItem(product: product, index: index);
                },
              ),
            );
          }),
        ],
      ),
      // 底部悬浮导航栏
      bottomNavigationBar: Obx(() {
        final total = productController.cart.fold(0.0, (sum, product) {
          return sum + (product['price2'] * product['quantity']);
        });

        return Container(
          color: Colors.white, // 设置底部悬浮框背景颜色为白色
          height: 65, // 控制高度
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        Text("Total : ",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[600])),
                        Text(
                          " \$${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                ElevatedButton(
                  onPressed: productController.cart.isEmpty
                      ? null // Disable button if cart is empty
                      : _checkout, // Otherwise, proceed to checkout
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: Size(150, 50), // 设置按钮的最小尺寸
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

// 处理结账功能

  // Checkout method without context
  void _checkout() {
    if (productController.cart.isEmpty) {
      return; // If cart is empty, do nothing
    }

    final orders = productController.cart.map((cartProduct) {
      // Ensure price, quantity, and other necessary fields are not null
      final price =
          cartProduct['price2'] ?? 0.0; // Default to 0.0 if price is null
      final quantity =
          cartProduct['quantity'] ?? 1; // Default to 1 if quantity is null
      final totalPrice = price * quantity; // Calculate total price

      // Create order data
      return {
        'manufacturer': cartProduct['manufacturer'] ?? 'Unknown',
        'productName': cartProduct['productName'] ?? 'Unknown',
        'price': price,
        'totalPrice': totalPrice,
        'origin': cartProduct['origin'] ?? 'Unknown',
        'unit': cartProduct['unit'] ?? '\$', // Default unit: dollar
        'info': cartProduct['info'] ?? 'N/A',
        'address': cartProduct['address'] ?? 'Unknown',
        'contact': cartProduct['contact'] ?? 'Unknown',
        'orderNumber': cartProduct['orderNumber'] ??
            'ORD${DateTime.now().millisecondsSinceEpoch}',
        'image': cartProduct['image'] ?? '',
        'quantity': quantity, // Keep quantity
      };
    }).toList();

    final dbService = DBService();
    for (var order in orders) {
      dbService.insertOrder(order); // Insert each order into the database
    }

    // Redirect to Orders Page
    Get.toNamed('/order');
  }
}
