import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/features/explore/views/screens/explore_screen.dart';
import 'package:real_estate_app/features/home/views/screens/home_screen.dart';
import 'package:real_estate_app/features/main/views/widgets/bottom_nav.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<Widget> screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const Center(child: Text("Favorites")),
    const Center(child: Text("My Bookings")),
    const Center(child: Text("Profile")),
  ];

  final List<NavItem> navItems = [
    NavItem(icon: Assets.icons.home, label: "Home"),
    NavItem(icon: Assets.icons.search, label: "Explore"),
    NavItem(icon: Assets.icons.heart, label: "Favorites"),
    NavItem(icon: Assets.icons.booking, label: "My Bookings"),
    NavItem(icon: Assets.icons.person, label: "Profile"),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
