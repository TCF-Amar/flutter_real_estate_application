import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/shared/widgets/app_text.dart';

class HomeSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final double barHeight;

  const HomeSearchBar({super.key, this.barHeight = 50});

  @override
  Size get preferredSize => Size.fromHeight(barHeight + 18);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.search);
      },
      child: Container(
        height: barHeight,
        margin: const EdgeInsets.fromLTRB(28, 0, 28, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.14),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: AppText(
                'Search Keyword',
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              width: 25,

              child: SvgPicture.asset(
                Assets.icons.search,
                colorFilter: ColorFilter.mode(
                  AppColors.primary.withValues(alpha: 0.5),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
