import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductReviewPage extends StatefulWidget {
  @override
  _ProductReviewPageState createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  int _rating = 5; // 默认评分为5星
  TextEditingController _reviewController = TextEditingController();
  List<Map<String, dynamic>> reviews = [];

  @override
  void initState() {
    super.initState();
    // 获取商品信息，传递过来的商品名称
    final product = Get.arguments;

    // 确保创建了一个新的可修改的 Map，并复制 reviews 列表
    final productData = Map<String, dynamic>.from(product); // 创建可修改的副本
    reviews = List<Map<String, dynamic>>.from(
        productData['reviews'] ?? []); // 复制 reviews 列表
  }

  // 提交评价的方法
  void _submitReview() {
    // 获取用户输入的评价
    final review = {
      'username': 'Your review', // 设置固定的用户名为 'Your review'
      'rating': _rating, // 获取用户选择的评分
      'comment': _reviewController.text, // 获取用户输入的评论
    };

    // 确保评论数据是 Map<String, Object> 类型
    final reviewData = {
      'username': review['username'],
      'rating': review['rating'],
      'comment': review['comment'],
    };

    // 获取商品并确保它存在
    final product = Get.arguments;
    if (product != null) {
      // 创建一个可修改的副本并向其中添加新的评论
      final productData = Map<String, dynamic>.from(product); // 创建副本
      List<Map<String, dynamic>> productReviews =
          List<Map<String, dynamic>>.from(productData['reviews'] ?? []);
      productReviews.add(reviewData); // 向商品的 reviews 中添加新的评论
      productData['reviews'] = productReviews; // 更新副本的 reviews

      // 使用 setState 来更新页面
      setState(() {
        reviews = List<Map<String, dynamic>>.from(productReviews); // 更新界面
      });
    }

    // 显示 Snackbar 或者进行其他操作
    Get.snackbar(
      "Review Submitted",
      "Your review has been submitted successfully!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // 清空评论框并返回上一页
    _reviewController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments; // 获取传递过来的商品信息
    return Scaffold(
      appBar: AppBar(
        title: Text('Item reviews'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品评价列表
            const Text(
              'User Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // 显示用户名
                                  Text(
                                    '${review['username']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(width: 8), // 给用户名和星星之间留一些空间
                                  // 显示星星
                                  Row(
                                    children: List.generate(
                                      review['rating'], // 根据评分显示星星
                                      (index) => const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8), // 添加间距让评论不和星星紧挨在一起
                              // 显示评论内容
                              Text(
                                '${review['comment']}',
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                maxLines: 3, // 限制最大显示3行
                                textAlign: TextAlign.left, // 确保评论文本左对齐
                              ),
                            ],
                          )));
                },
              ),
            ),
            const Divider(),
            // 新增评价
            const Text('Add your review', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              children: [
                // 星级评分选择器
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 1 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 1;//放星级为 1 时
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 2 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 3 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 3;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 4 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 4;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.star,
                      color: _rating >= 5 ? Colors.orange : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _rating = 5;
                    });
                  },
                ),
              ],
            ),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(hintText: 'Enter your review here'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _submitReview();
              },
              child: const Text(
                'Submit Review',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
