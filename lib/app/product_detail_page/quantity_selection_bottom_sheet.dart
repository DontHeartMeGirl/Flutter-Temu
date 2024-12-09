// quantity_selection_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_final_exam/app/controllers/product_controller.dart';
import 'package:get/get.dart';

//底部弹窗组件
class QuantitySelectionBottomSheet extends StatefulWidget {
  final Map<String, dynamic> product;

  const QuantitySelectionBottomSheet({Key? key, required this.product})
      : super(key: key);

  @override
  _QuantitySelectionBottomSheetState createState() =>
      _QuantitySelectionBottomSheetState();
}

class _QuantitySelectionBottomSheetState
    extends State<QuantitySelectionBottomSheet> {
  int quantity = 1;
  late double subtotal;
  final ProductController productController = Get.find();

  @override
  void initState() {
    super.initState();
    subtotal = widget.product['price2']; // 初始化小计
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
      subtotal = widget.product['price2'] * quantity; // 更新小计
    });
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        subtotal = widget.product['price2'] * quantity; // 更新小计
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  "\$${widget.product['price2']}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    "1 Piece",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          const Text(
            "Quantity:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _decreaseQuantity,
                icon: Icon(Icons.remove),
              ),
              Text(
                "$quantity",
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                onPressed: _increaseQuantity,
                icon: Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "Subtotal: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    " \$${subtotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // 先执行添加到购物车的操作
                  productController.addToCart(widget.product, quantity);

                  // 延迟执行，确保底部弹出框关闭后再弹出snackbar
                  Future.delayed(Duration(milliseconds: 200), () {
                    Navigator.pop(context); // 关闭底部弹出框

                    // 重置Snackbar状态
                    productController.resetSnackbar();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(210, 252, 206, 54), // 按钮背景颜色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 圆角效果
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
