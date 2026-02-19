import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _searchBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    // Expanded height = top padding + header row + headline + search bar
    final expandedHeight = topPadding + 280.0;

    return CustomScrollView(
      slivers: [
        // ── Sticky hero app bar ──────────────────────────────────────────
        SliverAppBar(
          pinned: true,
          expandedHeight: expandedHeight,
          collapsedHeight: kToolbarHeight + _searchBarHeight,
          backgroundColor: AppColors.background,
          elevation: 0,
          automaticallyImplyLeading: false,

          // Search bar stays pinned at the bottom of the app bar
          bottom: _StickySearchBar(height: _searchBarHeight),

          // Hero content collapses away on scroll
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: _HeroBackground(topPadding: topPadding),
          ),
        ),

        // ── Scrollable content ───────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: AppText(
              "Featured Properties",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),

        // Placeholder list items
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _PropertyCard(index: index),
            childCount: 10,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ─── Hero Background ──────────────────────────────────────────────────────────

class _HeroBackground extends StatelessWidget {
  final double topPadding;
  const _HeroBackground({required this.topPadding});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image(image: AssetImage(Assets.images.topImage), fit: BoxFit.cover),

        // Dark purple gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.background.withValues(alpha: 0.50),
                AppColors.background.withValues(alpha: 0.75),
                AppColors.background.withValues(alpha: 0.95),
              ],
              stops: const [0.0, 0.55, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Content
        Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: topPadding + 16,
            // leave room for the pinned search bar
            bottom: HomeScreen._searchBarHeight + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(Assets.images.getStart1),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "Hi, Shivam",
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        AppText(
                          "Good to see you.",
                          color: AppColors.white?.withValues(alpha: 0.65),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  _NotificationBell(),
                ],
              ),

              const Spacer(),

              // Headline
              AppText(
                "Find your perfect property to\nbuy or rent.",
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.35,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Sticky Search Bar (PreferredSizeWidget) ──────────────────────────────────

class _StickySearchBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  const _StickySearchBar({required this.height});

  @override
  Size get preferredSize => Size.fromHeight(height + 16); // +16 for padding

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(height / 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: AppText(
                "Search Keyword",
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Notification Bell ────────────────────────────────────────────────────────

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.white?.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: AppColors.white,
            size: 22,
          ),
        ),
        Positioned(
          top: 9,
          right: 9,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.background, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Placeholder Property Card ────────────────────────────────────────────────

class _PropertyCard extends StatelessWidget {
  final int index;
  const _PropertyCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.white?.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.white?.withValues(alpha: 0.08) ?? Colors.white10,
        ),
      ),
      child: Center(
        child: AppText(
          "Property ${index + 1}",
          color: AppColors.white?.withValues(alpha: 0.4),
          fontSize: 14,
        ),
      ),
    );
  }
}
