import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double? height, width;
  final double borderRadius;

  const Skeleton({super.key, this.height, this.width, this.borderRadius = 8});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        // padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}

class PropertySkeleton extends StatelessWidget {
  const PropertySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Skeleton
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Skeleton(
              height: 170,
              width: double.infinity,
              borderRadius: 20,
            ),
          ),

          // Details Skeleton
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Skeleton(height: 20, width: 200),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Skeleton(height: 16, width: 16, borderRadius: 4),
                    SizedBox(width: 8),
                    Skeleton(height: 14, width: 150),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Skeleton(height: 18, width: 80),
                    Row(
                      children: List.generate(
                        3,
                        (index) => const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              Skeleton(height: 16, width: 16, borderRadius: 4),
                              SizedBox(width: 4),
                              Skeleton(height: 14, width: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
