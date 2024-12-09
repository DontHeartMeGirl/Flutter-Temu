import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/category_products.dart'; // 引入商品数据文件

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});

  // 用于追踪选中的类别
  final RxString selectedCategory = 'Featured'.obs;
  RxString searchQuery = ''.obs;

  // 获取当前选中类别的商品
  List<Map<String, dynamic>> get selectedCategoryProducts {
    if (searchQuery.value.isEmpty) {
      return categoryProducts[selectedCategory.value] ?? [];
    } else {
      // 如果有搜索查询，过滤商品
      return categoryProducts[selectedCategory.value]?.where((product) {
            return product['name']
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase());
          }).toList() ??
          [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            onChanged: (query) {
              searchQuery.value = query;
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          // 左侧分类目录
          Container(
            width: 100, // 控制左侧宽度
            color: Colors.grey[200],
            child: ListView(
              children: categoryProducts.keys.map((category) {
                return Obx(() {
                  bool isSelected = selectedCategory.value == category;
                  return ListTile(
                    title: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.red : Colors.black,
                      ),
                    ),
                    selectedColor: isSelected
                        ? const Color.fromARGB(255, 230, 123, 123)
                        : Colors.transparent, // 如果是选中的目录，背景为白色
                    onTap: () {
                      selectedCategory.value = category; // 设置选中的类别
                    },
                  );
                });
              }).toList(),
            ),
          ),
          // 右侧商品目录
          Expanded(
            child: Obx(() {
              // 获取选中的类别的商品数据
              final categoryData =
                  categoryProducts[selectedCategory.value] ?? [];
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 每行3个商品
                  crossAxisSpacing: 10, // 水平间距
                  mainAxisSpacing: 10, // 垂直间距
                  childAspectRatio: 0.7, // 控制商品图片的宽高比
                ),
                itemCount: categoryData.length,
                itemBuilder: (context, index) {
                  final product = categoryData[index];
                  return Column(
                    children: [
                      ClipOval(
                        child: Image.network(
                          product['image'],
                          width: 66,
                          height: 66,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
