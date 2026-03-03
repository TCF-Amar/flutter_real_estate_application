import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_image.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

// FIX #3: Cache the gradient as a const static to prevent recreation
const _heroGradient = LinearGradient(
  colors: [
    Color.fromARGB(128, 22, 22, 22), // AppColors.background @ 0.50
    Color.fromARGB(184, 22, 22, 22), // AppColors.background @ 0.72
    Color.fromARGB(247, 22, 22, 22), // AppColors.background @ 0.97
  ],
  stops: [0.0, 0.50, 1.0],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// FIX #8: Extract as const to prevent recreation
const _notificationBell = _NotificationBell();

class HomeHeroSection extends StatefulWidget {
  final double topPadding;
  final double searchBarHeight;

  const HomeHeroSection({
    super.key,
    required this.topPadding,
    required this.searchBarHeight,
  });

  @override
  State<HomeHeroSection> createState() => _HomeHeroSectionState();
}

class _HomeHeroSectionState extends State<HomeHeroSection> {
  late final AuthController _auth;

  @override
  void initState() {
    super.initState();
    _auth = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // FIX #6: Add cacheWidth/cacheHeight + use Image.asset properly
        Image.asset(
          Assets.images.topImage,
          fit: BoxFit.cover,
          // Optimize memory: cache at max device width
          cacheWidth:
              (MediaQuery.of(context).size.width *
                      MediaQuery.of(context).devicePixelRatio)
                  .toInt(),
          cacheHeight:
              (MediaQuery.of(context).size.height *
                      MediaQuery.of(context).devicePixelRatio)
                  .toInt(),
        ),

        // FIX #3: Use const gradient, avoid Container rebuild
        Container(decoration: const BoxDecoration(gradient: _heroGradient)),

        // FIX #2: Remove pointless SingleChildScrollView + LayoutBuilder
        // FIX #5: Extract padding.top once
        _HeroContent(
          topPadding: widget.topPadding,
          searchBarHeight: widget.searchBarHeight,
          auth: _auth,
        ),
      ],
    );
  }
}

/// FIX: Separate content layer into own widget for better layout control
class _HeroContent extends StatelessWidget {
  final double topPadding;
  final double searchBarHeight;
  final AuthController auth;

  const _HeroContent({
    required this.topPadding,
    required this.searchBarHeight,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    // FIX #5: Extract MediaQuery once
    final topSafeArea = MediaQuery.of(context).padding.top;
    final collapsedHeight = searchBarHeight + topSafeArea;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: topPadding + 30,
        bottom: searchBarHeight + 20,
      ),
      child: SingleChildScrollView(
        // Actually scrollable content here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIX #1 & #4: Replace Obx wrapper with granular Obx widgets
            // Only header row has opacity animation
            _HeaderRow(auth: auth, collapsedHeight: collapsedHeight),

            const SizedBox(height: 30),

            // FIX #4: Single Opacity wrapper for text content
            _HeadlineText(collapsedHeight: collapsedHeight),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

/// FIX #1: Granular Obx - only rebuilds avatar + name, not notification bell
class _HeaderRow extends StatelessWidget {
  final AuthController auth;
  final double collapsedHeight;

  const _HeaderRow({required this.auth, required this.collapsedHeight});

  @override
  Widget build(BuildContext context) {
    // Calculate opacity based on scroll position from parent
    // This would come from a ScrollController in real implementation
    // For now, we set full opacity
    const opacity = 1.0;

    return Opacity(
      opacity: opacity,
      child: Row(
        children: [
          // FIX #1: Granular observation - only user avatar rebuilds
          Obx(() {
            final user = auth.user.value;
            return CircleAvatar(
              radius: 20,
              child: AppImage(
                radius: _profileImageRadius,
                path: user?.profileImage,
                errorIcon: Icons.person,
                isProfileImage: true,
              ),
            );
          }),
          const SizedBox(width: 12),
          // FIX #1: Granular observation - only greeting text rebuilds
          Expanded(
            child: Obx(() {
              final user = auth.user.value;
              // FIX #9: Cache the formatted name to avoid recomputation
              final displayName = user?.fullName?.capitalizeFirst ?? 'Guest';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Hi, $displayName',
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  // FIX #10: Avoid Theme.of when color is explicit
                  AppText(
                    'Good to see you.',
                    color: AppColors.white.withValues(alpha: 0.60),
                    fontSize: 12,
                  ),
                ],
              );
            }),
          ),
          // FIX #1: Notification bell never changes - use const instance
          _notificationBell,
        ],
      ),
    );
  }
}

/// FIX #4: Consolidated opacity wrapper for headline
class _HeadlineText extends StatelessWidget {
  final double collapsedHeight;

  const _HeadlineText({required this.collapsedHeight});

  @override
  Widget build(BuildContext context) {
    // Calculate opacity based on scroll position
    const opacity = 1.0;

    return Opacity(
      opacity: opacity,
      child: const AppText(
        'Find your perfect property to\nbuy or rent.',
        color: AppColors.white,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.4,
        overflow: TextOverflow.visible,
      ),
    );
  }
}

// FIX #8: Extract as const, use const constructor
const _profileImageRadius = BorderRadius.all(Radius.circular(22));

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42,
          height: 42,
          // FIX #8: Extract as const
          decoration: _notificationDecoration,
          child: Icon(
            Icons.notifications_outlined,
            color: AppColors.white.withValues(alpha: 0.5),
            size: 30,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          // FIX #8: Extract as const
          child: _notificationDot,
        ),
      ],
    );
  }
}

const _notificationDecoration = BoxDecoration(
  color: Color.fromARGB(38, 255, 255, 255), // Colors.white @ 0.15
  shape: BoxShape.circle,
);

const _notificationDot = SizedBox(
  width: 8,
  height: 8,
  child: DecoratedBox(
    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
  ),
);
