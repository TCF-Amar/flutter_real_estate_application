import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/initial/models/onboarding_page_data.dart';
import 'package:real_estate_app/features/initial/views/widgets/onboarding_page_item.dart';

/// Main onboarding screen that displays a PageView of onboarding pages
class GetStartScreens extends StatefulWidget {
  const GetStartScreens({super.key});

  @override
  State<GetStartScreens> createState() => _GetStartScreensState();
}

class _GetStartScreensState extends State<GetStartScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingPageData> _pages = OnboardingPageData.pages;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final int nextPage = _pageController.page?.round() ?? 0;
    if (_currentPage != nextPage) {
      setState(() {
        _currentPage = nextPage;
      });
    }
  }

  void _handleNext(int currentPageIndex) {
    if (currentPageIndex == _pages.length - 1) {
      // Navigate to login on the last page
      Get.toNamed(AppRoutes.login);
    } else {
      // Animate to next page
      _pageController.animateToPage(
        currentPageIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return OnboardingPageItem(
            pageData: _pages[index],
            pageIndex: index,
            currentPage: _currentPage,
            totalPages: _pages.length,
            onPressed: () => _handleNext(index),
          );
        },
      ),
    );
  }
}
