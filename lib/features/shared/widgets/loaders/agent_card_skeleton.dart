import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';

/// A shimmer skeleton that mirrors the exact layout of [ExploreAgentCard].
/// Shown while the initial agents list is loading.
class AgentCardSkeleton extends StatefulWidget {
  const AgentCardSkeleton({super.key});

  @override
  State<AgentCardSkeleton> createState() => _AgentCardSkeletonState();
}

class _AgentCardSkeletonState extends State<AgentCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, _) =>
          Opacity(opacity: _animation.value, child: _buildCard()),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circle avatar
              _box(width: 50, height: 50, radius: 25),
              const SizedBox(width: 12),
              // Name / agency / location lines
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(width: double.infinity, height: 13),
                    const SizedBox(height: 6),
                    _box(width: 140, height: 11),
                    const SizedBox(height: 4),
                    _box(width: 100, height: 9),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _box(width: 36, height: 36, radius: 18),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (_) => _statBlock()),
          ),

          const SizedBox(height: 12),

          // ── Description lines ───────────────────────────────
          _box(width: double.infinity, height: 10),
          const SizedBox(height: 5),
          _box(width: double.infinity, height: 10),
          const SizedBox(height: 5),
          _box(width: 180, height: 10),
        ],
      ),
    );
  }

  /// One of the three stat columns (icon placeholder + two text lines).
  Widget _statBlock() {
    return Row(
      children: [
        _box(width: 20, height: 20),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(width: 60, height: 10),
            const SizedBox(height: 4),
            _box(width: 40, height: 8),
          ],
        ),
      ],
    );
  }

  /// A rounded grey box used as a placeholder for any element.
  Widget _box({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Renders [count] skeleton cards in a non-scrollable list.
/// Use this inside an [Expanded] or [SizedBox] constrained parent.
class AgentListSkeleton extends StatelessWidget {
  final int count;
  const AgentListSkeleton({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, _) => const AgentCardSkeleton(),
    );
  }
}
