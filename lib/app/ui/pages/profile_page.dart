import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/data/services/db_service.dart';
import '../../profile/profile_options_list.dart';
import '../../profile/profile_header.dart';
import '../../profile/profile_dialog.dart';
import '../../profile/profile_banner.dart';

final DBService dbService = DBService();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;
  Map<String, dynamic>? currentUser;
  bool hasCheckedLoginStatus = false;
  bool isDialogShown = false;

  @override
  void initState() {
    super.initState();
    _initializeLoginStatus();
  }

  Future<void> _initializeLoginStatus() async {
    isLoggedIn = await dbService.getLoginStatus();
    if (isLoggedIn) {
      currentUser = await dbService.getCurrentUser();
    }
    setState(() {
      hasCheckedLoginStatus = true;
    });
  }

  void _showProfileDialog() {
    if (isDialogShown || isLoggedIn) return;

    isDialogShown = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => ProfileDialog(
        onLoginSuccess: () async {
          currentUser = await dbService.getCurrentUser();
          setState(() {
            isLoggedIn = true;
          });
          isDialogShown = false;
        },
      ),
    ).whenComplete(() {
      isDialogShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasCheckedLoginStatus) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isDialogShown) {
          _showProfileDialog();
        }
      });
      return Scaffold(
        appBar: AppBar(title: const Text("Profile Page")),
        body: const Center(child: Text("请先登录")),
      );
    } else {
      return _buildLoggedInView();
    }
  }

  Widget _buildLoggedInView() {
    final account = currentUser?['account'] ?? '';
    final initial = account.isNotEmpty ? account[0].toUpperCase() : '';

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(account: account, initial: initial),
          const ProfileBanner(),
          const Expanded(child: ProfileOptionsList()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await dbService.setLoginStatus(false);
                  setState(() {
                    isLoggedIn = false;
                    currentUser = null;
                  });
                  Get.snackbar(
                    "Logged out",
                    "You have been logged out successfully.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                },
                child: const Text("Logout"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
