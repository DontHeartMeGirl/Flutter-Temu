import 'package:flutter/material.dart';

//商品价格显示组件
class ProductPriceDisplay extends StatelessWidget {
  final double price1;
  final double price2;

  const ProductPriceDisplay({
    required this.price1,
    required this.price2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 13,
          ),
          child: Text(
            "ALMOST SOLD OUT",
            style: TextStyle(fontSize: 17, color: Colors.orange),
          ),
        ),
        Text(
          " \$${price2}", //折扣价
          style: const TextStyle(
            fontSize: 26,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "\$${price1}", //原价
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }
}
