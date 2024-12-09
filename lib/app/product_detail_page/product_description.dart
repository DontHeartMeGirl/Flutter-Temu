import 'package:flutter/material.dart';

// 商品描述组件
class ProductDescription extends StatelessWidget {
  final String? ingredients;
  final String? origin;
  final String? manufacturer;
  final String? manufacturerId;
  final String? orderNumber;

  const ProductDescription({
    this.ingredients, // 现在是可空类型
    this.origin,
    this.manufacturer,
    this.manufacturerId,
    this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow("Ingredients:", ingredients ?? 'No Information'), // 提供默认值
          _buildRow("Origin:", origin ?? 'No Information'), // 提供默认值
          _buildRow("Manufacturer:", manufacturer ?? 'No Information'), // 提供默认值
          _buildRow(
              "Manufacturer ID:", manufacturerId ?? 'No Information'), // 提供默认值
          _buildRow("Order Number:", orderNumber ?? 'No Information'), // 提供默认值
        ],
      ),
    );
  }

  Row _buildRow(String title, String value) {
    return Row(
      children: [
        Text(
          "$title",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            " $value", // 显示值，如果为空则显示默认值
            style: const TextStyle(fontSize: 16),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
