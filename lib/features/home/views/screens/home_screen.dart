import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/home/views/widgets/featured_properties_section.dart';
import 'package:real_estate_app/features/home/views/widgets/home_hero_section.dart';
import 'package:real_estate_app/features/home/views/widgets/home_search_bar.dart';
import 'package:real_estate_app/features/home/views/widgets/recommended_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _searchBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final expandedHeight = topPadding + 200.0;

    return CustomScrollView(
      slivers: [
        // ── AppBar with Sticky Top Search Bar ──────────────────────────
        SliverAppBar(
          pinned: true,
          expandedHeight: expandedHeight,
          backgroundColor: AppColors.background,
          surfaceTintColor: AppColors.background,
          elevation: 0,

          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(_searchBarHeight),
            child: Transform.translate(
              offset: const Offset(0, _searchBarHeight / 2),
              child: const HomeSearchBar(barHeight: _searchBarHeight),
            ),
          ),

          flexibleSpace: HomeHeroSection(
            topPadding: topPadding,
            searchBarHeight: _searchBarHeight,
          ),
        ),

        SliverToBoxAdapter(
          
          child: Transform.translate(
            offset: const Offset(0, (_searchBarHeight / 2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                FeaturedPropertiesSection(),
                RecommendedSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
