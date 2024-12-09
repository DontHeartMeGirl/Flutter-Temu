import 'package:get/get.dart';
import '../data/models/product.dart'; // 导入商品数据

class HomeController extends GetxController {
  var selectedCategory = "All".obs;//当前选中的分类
  var products = <Map<String, dynamic>>[].obs;//当前显示的商品列表

  @override
  void onInit() {
    super.onInit();
    loadProductsForCategory("All");//默认加载 "Women" 分类
  }
   //切换分类并更新商品数据
  void loadProductsForCategory(String category) {
    selectedCategory.value = category;
    products.value = categoryProducts[category] ?? [];
  }
}

