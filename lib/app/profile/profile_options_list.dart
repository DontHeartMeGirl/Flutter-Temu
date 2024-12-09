import 'package:flutter/material.dart';
import 'package:get/get.dart';

//ListTile 功能列表
class ProfileOptionsList extends StatelessWidget {
  const ProfileOptionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 0),
      children: [
        ListTile(
          leading: const Icon(Icons.message_outlined),
          title: const Text("Messages"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(
            Icons.shopping_bag,
            color: Color.fromARGB(255, 252, 144, 2),
          ),
          title: const Text(
            "Your orders",
            style: TextStyle(color: Color.fromARGB(255, 252, 144, 2)),
          ),
          onTap: () {
            Get.toNamed('/order');
          },
        ),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text("Your reviews"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.local_offer),
          title: const Text("Coupons & offers"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: const Text("Credit balance"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text("Addresses"),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text("Language"),
          onTap: () {},
        ),
      ],
    );
  }
}
