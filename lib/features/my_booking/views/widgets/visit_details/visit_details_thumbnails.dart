import 'package:flutter/material.dart';
import 'package:real_estate_app/features/my_booking/models/visit_detail_response.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitDetailsThumbnails extends StatelessWidget {
  final List<PropertyImage> images;
  final int selectedIndex;
  final Function(int) onImageSelected;

  const VisitDetailsThumbnails({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: AppContainer(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(0),
        height: 70,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          itemCount: images.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final image = images[index];
            return GestureDetector(
              onTap: () => onImageSelected(index),
              child: AppContainer(
                padding: const EdgeInsets.all(0),
                width: 70,
                showBorder: true,
                border: selectedIndex == index
                    ? Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      )
                    : null,
                child: AppImage(
                  radius: BorderRadius.circular(12),
                  path: image.url ?? '',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
