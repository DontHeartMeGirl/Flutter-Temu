import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart'; // 引入控制器
import '../../product_detail_page/product_description.dart';
import '../../product_detail_page/product_image_carousel.dart';
import '../../product_detail_page/product_price_display.dart';
import '../../product_detail_page/quantity_selection_bottom_sheet.dart';
import '../../data/services/db_service.dart'; // 引入 DatabaseService

//商品详情界面
class ProductDetailPage extends StatefulWidget {
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final PageController _pageController = PageController();
  final ProductController productController = Get.find();
  int _currentPage = 0;
  final currentTime = DateTime.now().toIso8601String(); // 获取当前时间，格式化为 ISO 字符串

  @override
  Widget build(BuildContext context) {
    // 获取传递过来的商品数据
    final product = Get.arguments;

    // 确保 image 字段存在并且是一个列表
    final List<String> images = (product['image'] is List<String>)
        ? List<String>.from(product['image'])
        : [product['image'] ?? '']; // 如果没有图片，给一个空的默认值

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 商品图片轮播

                ProductImageCarousel(
                  images: images,
                  currentPage: _currentPage,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    product['name'] ?? 'No Name', // 确保商品名称存在
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                ProductPriceDisplay(
                    price1: product['price1'], price2: product['price2']),
                const Divider(
                    color: Color.fromARGB(255, 236, 233, 233), thickness: 5 //厚度
                    ), //横线
                // 商品评价按钮
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed('/review', arguments: product); // 跳转到商品评价页面
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              "商品评价",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ],
                        ),
                        Text("See All >")
                      ],
                    ),
                  ),
                ),
                const Divider(
                    color: Color.fromARGB(255, 236, 233, 233), thickness: 5 //厚度
                    ),
                const Padding(
                  padding: EdgeInsets.only(left: 13, top: 5),
                  child: Text("Product details:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                const Divider(color: Colors.grey, thickness: 0.2), //横线
                ProductDescription(
                  ingredients: product['ingredients'],
                  origin: product['origin'],
                  manufacturer: product['manufacturer'],
                  manufacturerId: product['manufacturerId'],
                  orderNumber: product['orderNumber'],
                ),
              ],
            ),
          ),
          // 返回按钮放置在图片左上角
          Positioned(
            top: 40,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // 返回上一页
              },
              child: Container(
                width: 30, // 按钮宽度
                height: 30, // 按钮高度
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // 圆形按钮
                  color: Color.fromARGB(255, 43, 42, 42), // 按钮背景色
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white, // 返回按钮图标颜色
                  size: 24, // 图标大小
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 72,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // "Buy Now"按钮
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  // 获取商品信息
                  final product = Get.arguments;

                  final order = {
                    'quantity': 1,
                    'manufacturer': product['manufacturer'],
                    'productName': product['name'], //商品名称
                    'price': product['price2'], //商品价格
                    'origin': product['origin'] ?? 'Unknown',
                    'unit': '\$', // 单位: "美元"
                    'info': product['ingredients'] ?? 'N/A', //商品材料、判断是否为空
                    'address': product['address'] ?? 'Unknown', // 默认地址
                    'contact': product['contact'] ?? 'Unknown', // 默认联系方式
                    'orderNumber': product['orderNumber'] ??
                        'ORD${DateTime.now().millisecondsSinceEpoch}',
                    'image': product['image'][0], // 获取商品的第一张图片
                    'orderTime': currentTime, // 添加当前时间字段
                  };

                  final dbService = DBService();
                  await dbService.insertOrder(order); // 将订单信息插入数据库
                  // 跳转到订单页面
                  Get.toNamed('/order');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 160, 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Buy Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // "加入购物车"按钮
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5),
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) =>
                          QuantitySelectionBottomSheet(product: product),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(210, 252, 206, 54),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
