import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SupportTopic {
  final String path;
  final String title;
  const SupportTopic({required this.path, required this.title});
}

// ── Topic card ───────────────────────────────────────────────────────────────

class TopicCard extends StatelessWidget {
  final SupportTopic topic;
  const TopicCard({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 44,
              width: 44,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: AppSvg(
                path: topic.path,
                color: AppColors.primary,
                height: 15,
                width: 15,
              ),
            ),
            const SizedBox(height: 10),
            AppText(topic.title, fontSize: 16, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
