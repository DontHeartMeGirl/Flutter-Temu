import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import 'categories_page.dart';
import 'profile_page.dart';
import 'cart_page.dart';
import '../widgets/product_card.dart';
import '../../utils/dialog_helper.dart';
import '../../utils/animation_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.find();
  int _selectedIndex = 0;

  //定义页面列表
  final List<Widget> _pages = [
    HomeContentPage(),
    CategoriesPage(),
    const ProfilePage(),
    CartPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 更新选中的页面索引
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            const Color.fromARGB(255, 244, 79, 54), // 选中的icon颜色设置为红色
        unselectedItemColor: Colors.grey, // 未选中的icon颜色设置为灰色
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
      body: _pages[_selectedIndex], // 根据_selectedIndex 显示对应页面
    );
  }
}

class HomeContentPage extends StatefulWidget {
  @override
  _HomeContentPageState createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  final HomeController homeController = Get.find();
  bool _showDot = false; // 控制圆点显示
  double _dotX = 0; // 圆点的 X 坐标
  double _dotY = 0; // 圆点的 Y 坐标

  void _startCartAnimation(BuildContext buttonContext) {
    RenderBox box = buttonContext.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);

    setState(() {
      _showDot = true;
      _dotX = position.dx;
      _dotY = position.dy;
    });

    AnimationHelper.startCartAnimation(
      context: context,
      startPosition: position,
      onPositionUpdate: (newPosition) {
        setState(() {
          _dotX = newPosition.dx;
          _dotY = newPosition.dy;
        });
      },
      onComplete: () {
        setState(() {
          _showDot = false;
        });
      },
    );
  }

  Widget _buildCategoryButton(String label) {
    return Obx(() {
      final isSelected =
          homeController.selectedCategory.value == label; // 确保动态依赖
      return GestureDetector(
        onTap: () {
          homeController.loadProductsForCategory(label); // 更新选中的类别
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 20,
                  color: Colors.black,
                ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // 搜索框
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 25, 0, 0),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 13, right: 7),
                        child: Icon(Icons.search, size: 20),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      // 实现搜索过滤逻辑
                    },
                  ),
                ),
              ),
            ),

            // 顶部导航栏
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryButton("All"),
                    _buildCategoryButton("Women"),
                    _buildCategoryButton("Men"),
                    _buildCategoryButton("Kids"),
                    _buildCategoryButton("Sports"),
                    _buildCategoryButton("Toy"),
                    _buildCategoryButton("Bags"),
                    _buildCategoryButton("Garden"),
                  ],
                ),
              ),
            ),

            // 带背景颜色的文字区域
            Container(
              color: Colors.amber[100],
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 0, right: 0),
                          child: Icon(Icons.check_circle,
                              color: Colors.green, size: 20),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Free shipping special for you",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Exclusive offer",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Obx(() {
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //每行展示 2 个商品卡片
                    mainAxisSpacing: 3, //每一行之间的垂直间距为 3
                    crossAxisSpacing: 3, //每一列之间的水平间距为 3
                    childAspectRatio: 0.7, //宽高比
                  ),
                  itemCount: homeController.products.length,
                  itemBuilder: (context, index) {
                    //动态创建每个商品卡片（ProductCard），将商品数据绑定到卡片上。
                    final product = homeController.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Get.toNamed('/product-detail',
                            arguments:
                                product); //点击卡片后，通过Get.toNamed跳转到商品详情页，并传递商品数据。
                      },
                      onCartButtonTap: (buttonContext) {
                        _startCartAnimation(buttonContext);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),

        // 动画圆点
        if (_showDot)
          AnimatedPositioned(
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOutSine,
            left: _dotX,
            top: _dotY,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut, //圆点大小变化的曲线
              width: _showDot ? 15 : 10, //动态调整宽度
              height: _showDot ? 15 : 10, //动态调整高度
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          )
      ],
    );
  }
}
