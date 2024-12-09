import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/db_service.dart'; // 引入 DatabaseService
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  DBService dbService = DBService(); // 获取DBService实例
  late Future<List<Map<String, dynamic>>> orders; // 用来显示订单列表

  @override
  void initState() {
    super.initState();
    orders = dbService.getOrders(); // 获取所有订单
  }

  void deleteOrder(int id) async {
    await dbService.deleteOrder(id); // 删除订单
    setState(() {
      orders = dbService.getOrders(); // 更新订单列表
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        centerTitle: true, // 使 title 居中
        backgroundColor: const Color.fromARGB(255, 240, 236, 236),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // 点击购物车图标时的操作
              Get.toNamed('/cart');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No order details available.'));
          }

          final orderList = snapshot.data!;

          return ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              final order = orderList[index];
              final orderTime = DateTime.parse(order['orderTime']); //解析订单时间
              final formattedTime =
                  DateFormat('yyyy-MM-dd HH:mm').format(orderTime);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 221, 220, 220), width: 0.5),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Right top "Order Placed" text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${order['manufacturer']}",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Order Placed",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      // 商品图片、名称、价格放在同一行
                      Row(
                        children: [
                          // 商品图片
                          Image.network(
                            order['image'] ?? '',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          // 商品名称
                          Expanded(
                            child: Text(
                              order['productName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis, // 文本超出时显示省略号
                              maxLines: 1, // 只显示一行
                            ),
                          ),
                          // 商品价格
                          Column(
                            children: [
                              Text(
                                '\$${order['price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Text('\× ${order['quantity']}'), // 显示数量
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 8),

                      //商品信息

                      Text('Origin: ${order['origin']}'),
                      Text('Unit: ${order['unit']}'),
                      Text('Info: ${order['info']}'),
                      Text('Address: ${order['address']}'),
                      Text('Contact: ${order['contact']}'),

                      const SizedBox(height: 3),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, //子元素左对齐
                            children: [
                              Text(
                                'Amount Paid : \$${(order['price'] * order['quantity']).toStringAsFixed(2)}', // 显示总价
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              Text(
                                "Order Time: $formattedTime",
                                style: TextStyle(fontSize: 11),
                              ), // 显示格式化后的时间
                            ],
                          ),
                          // Delete Order button with background color
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.redAccent, // 背景颜色
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextButton(
                              onPressed: () {
                                deleteOrder(order['id']);
                              },
                              child: const Text(
                                'Delete Order',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
