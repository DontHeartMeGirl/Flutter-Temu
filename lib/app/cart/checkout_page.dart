// // checkout_page.dart

// class CheckoutPage extends StatelessWidget {
//   final CartController cartController = Get.find();

//   void _checkout() async {
//     final dbService = DBService();
//     double totalAmount = 0;

//     for (var item in cartController.cartItems) {
//       totalAmount += item['price'] * item['quantity']; // 计算总金额

//       // 插入订单数据
//       final order = {
//         'manufacturer': item['manufacturer'],
//         'productName': item['name'],
//         'price': item['price'],
//         'totalPrice': item['price'] * item['quantity'], // 总价
//         'origin': item['origin'],
//         'unit': item['unit'],
//         'info': item['info'],
//         'address': item['address'],
//         'contact': item['contact'],
//         'orderNumber': 'ORD${DateTime.now().millisecondsSinceEpoch}',
//         'image': item['image'],
//         'quantity': item['quantity'],
//       };

//       await dbService.insertOrder(order); // 插入数据库
//     }

//     // 跳转到订单页面并传递总价
//     Get.toNamed('/order', arguments: {'totalAmount': totalAmount});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Checkout")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: cartController.cartItems.isEmpty ? null : _checkout,
//           child: Text('Checkout'),
//         ),
//       ),
//     );
//   }
// }
