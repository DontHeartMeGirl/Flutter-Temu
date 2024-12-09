import 'package:flutter_final_exam/app/routes/app_routes.dart';
import 'package:get/get.dart';
import '../ui/pages/login_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/product_detail_page.dart';
import '../ui/pages/cart_page.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/product_binding.dart';
import '../ui/pages/orders_page.dart';
import '../ui/pages/review_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/login',
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/product-detail',
      page: () => ProductDetailPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: '/cart',
      page: () => CartPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: '/order',
      page: () => OrdersPage(),
      // binding: ProductBinding(),
    ),
    GetPage(
      name: '/review',
      page: () => ProductReviewPage(),
      // binding: ProductBinding(),
    ),
  ];
}
