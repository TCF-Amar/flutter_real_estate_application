import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/agent/models/graph_data_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class Graph extends StatelessWidget {
  final GraphDataModel? graphData;

  const Graph({super.key, required this.graphData});

  @override
  Widget build(BuildContext context) {
    if (graphData == null) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _chartCard(
            "Property Type",
            graphData!.propertyTypeStatsMap,
            graphData!.propertyTypeStats.isEmpty,
          ),
          const SizedBox(height: 20),
          _chartCard(
            "Property Status",
            graphData!.propertyStatusStatsMap,
            graphData!.propertyStatusStats.isEmpty,
          ),
          const SizedBox(height: 20),
          _chartCard(
            "Property Cities",
            graphData!.propertyCityStatsMap,
            graphData!.propertyCityStats.isEmpty,
          ),
        ]),
      ),
    );
  }

  Widget _chartCard(String title, Map<String, double> data, bool isEmpty) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Center(child: AppText(title, fontSize: 16)),
          ),
          isEmpty || data.containsKey("No Data")
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: AppText("No Data Available"),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: RepaintBoundary(
                    child: PieChart(
                      dataMap: data,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 20,
                      chartRadius: 100,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 20,
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValues: false,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
