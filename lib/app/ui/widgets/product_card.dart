import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';

// 商品卡片
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final void Function(BuildContext) onCartButtonTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
    required this.onCartButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 处理 image 字段为 List<String> 或 String 的情况
    final productController = Get.find<ProductController>();
    final imageUrl = product['image'] is List<String>
        ? (product['image'] as List<String>)[0] // 如果是 List<String>，取第一张图片
        : product['image'] as String; // 否则直接使用 String

    return GestureDetector(
      onTap: () {
        Get.toNamed('/product-detail',
            arguments: product); // 使用 Get.toNamed 传递商品数据
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.network(
                      imageUrl, // 使用处理后的图片 URL
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product['name'],
                    maxLines: 2, // 限制为单行显示
                    overflow: TextOverflow.clip, // 超出部分不显示
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "\$${product['price2']}",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "\$${product['price1']}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Builder(
                builder: (buttonContext) {
                  return SizedBox(
                    height: 25,
                    width: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        onCartButtonTap(buttonContext);
                        productController.addToCart(product, 1); // 默认添加1件商品
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder(),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        size: 17,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
