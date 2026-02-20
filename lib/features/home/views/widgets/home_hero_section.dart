import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

/// Collapsible hero background that lives inside [FlexibleSpaceBar].
/// Shows the avatar, greeting, headline and fades away on scroll.
class HomeHeroSection extends StatelessWidget {
  final double topPadding;
  final double searchBarHeight;

  const HomeHeroSection({
    super.key,
    required this.topPadding,
    required this.searchBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find();
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(Assets.images.topImage, fit: BoxFit.cover),

        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.background.withValues(alpha: 0.50),
                AppColors.background.withValues(alpha: 0.72),
                AppColors.background.withValues(alpha: 0.97),
              ],
              stops: const [0.0, 0.50, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // ── Content layer ────────────────────────────────────────────────
        LayoutBuilder(
          builder: (context, constraints) {
            // Calculate a visibility threshold
            // searchBarHeight + topPadding is roughly the collapsed height (approx 80-100)
            final currentHeight = constraints.maxHeight;
            final collapsedHeight =
                searchBarHeight + MediaQuery.of(context).padding.top;

            double opacity = ((currentHeight - collapsedHeight) / 80).clamp(
              0.0,
              1.0,
            );

            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: topPadding + 30,
                  bottom: searchBarHeight + 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row ─ avatar + greeting + bell
                    Opacity(
                      opacity: opacity,
                      child: Obx(() {
                        final user = auth.user.value;
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white24,
                              backgroundImage:
                                  (user?.profileImage != null &&
                                      user!.profileImage!.isNotEmpty)
                                  ? NetworkImage(user.profileImage!)
                                  : null,
                              child:
                                  (user?.profileImage == null ||
                                      user!.profileImage!.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 28,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    'Hi, ${user?.fullName?.capitalizeFirst ?? 'Guest'}',
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  AppText(
                                    'Good to see you.',
                                    color: AppColors.white.withValues(
                                      alpha: 0.60,
                                    ),
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            _NotificationBell(),
                          ],
                        );
                      }),
                    ),

                    const SizedBox(height: 30),

                    // Headline
                    Opacity(
                      opacity: opacity,
                      child: AppText(
                        'Find your perfect property to\nbuy or rent.',
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: AppColors.white.withValues(alpha: 0.5),
            size: 30,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
