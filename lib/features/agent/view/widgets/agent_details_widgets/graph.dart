import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/models/graph_data_model.dart';
import 'package:real_estate_app/features/agent/view/widgets/graph_detail_dialog.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

/// Curated color palette that complements the app's purple brand color.
const List<Color> _chartColors = [
  Color(0xFF885EFF), // primary purple
  Color(0xFFB39DFF), // light purple
  Color(0xFF5E35B1), // deep purple
  Color(0xFFFF7043), // warm coral
  Color(0xFF26C6DA), // teal accent
  Color(0xFFFFA000), // amber
  Color(0xFF66BB6A), // muted green
];

class Graph extends StatelessWidget {
  final GraphDataModel? graphData;

  const Graph({super.key, required this.graphData});

  @override
  Widget build(BuildContext context) {
    if (graphData == null) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _ChartCard(
            title: 'Property Type',
            data: graphData!.propertyTypeStatsMap,
            isEmpty: graphData!.propertyTypeStats.isEmpty,
            onTap: () => showGraphDetailDialog(
              context,
              graphData!.propertyTypeStatsDetails,
              "Property Type",
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Property Status',
            data: graphData!.propertyStatusStatsMap,
            isEmpty: graphData!.propertyStatusStats.isEmpty,
            onTap: () => showGraphDetailDialog(
              context,
              graphData!.propertyStatusStatsDetails,
              "Property Status",
            ),
          ),
          const SizedBox(height: 16),
          _ChartCard(
            title: 'Property Cities',
            data: graphData!.propertyCityStatsMap,
            isEmpty: graphData!.propertyCityStats.isEmpty,
            onTap: () => showGraphDetailDialog(
              context,
              graphData!.propertyCityStatsDetails,
              "Property Cities",
            ),
          ),
        ]),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final bool isEmpty;
  final VoidCallback onTap;

  const _ChartCard({
    required this.title,
    required this.data,
    required this.isEmpty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive ring size — takes roughly 38% of the card width.
    final chartRadius = (screenWidth - 40) * 0.38;

    final hasData = !isEmpty && !data.containsKey('No Data');

    return GestureDetector(
      onTap: hasData ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.grey.withValues(alpha: 0.12),
                    AppColors.grey.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: AppText(
                  title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              //  Row(
              //   children: [
              //     Expanded(
              //       child: AppText(
              //         title,
              //         fontSize: 15,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     if (hasData)
              //       Icon(
              //         Icons.open_in_full_rounded,
              //         size: 14,
              //         color: AppColors.textSecondary,
              //       ),
              //   ],
              // ),
            ),

            // ── Body ─────────────────────────────────────────────────────────
            if (!hasData)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: AppText(
                    'No Data Available',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                child: RepaintBoundary(
                  child: PieChart(
                    dataMap: data,
                    animationDuration: const Duration(milliseconds: 600),
                    chartRadius: chartRadius,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 22,
                    colorList: _chartColors,
                    chartLegendSpacing: 16,
                    legendOptions: const LegendOptions(
                      // showLegendsInRow: true,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValueBackground: false,
                      chartValueStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
