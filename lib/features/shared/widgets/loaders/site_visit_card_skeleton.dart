import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VisitCardSkeleton extends StatelessWidget {
  const VisitCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        period: Duration(milliseconds: 1500),
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image - Rounded corner
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey[300]!, Colors.white],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),

              // Content Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Container(
                      height: 18,
                      width: 140,
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),

                    // Location + Phone Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Location icon
                        Container(
                          width: 16,
                          height: 16,
                          margin: EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        // Location text
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Spacer(),

                        // Phone number
                      ],
                    ),

                    SizedBox(height: 12),

                    // Date + Time Row
                    Row(
                      children: [
                        Container(
                          height: 14,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          height: 14,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Status Tag - Bottom right
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          height: 24,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
