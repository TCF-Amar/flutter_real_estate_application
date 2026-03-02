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
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,

          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: const AppText(
                        "Property Type",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Center(
                      child: PieChart(
                        dataMap: graphData!.propertyTypeStatsMap,
                        animationDuration: Duration(milliseconds: 800),

                        chartLegendSpacing: 20,
                        chartRadius: 100,
                        // colorList: ,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 20,

                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: false,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: const AppText(
                        "Property Status",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Center(
                      child: PieChart(
                        dataMap: graphData!.propertyStatusStatsMap,
                        animationDuration: Duration(milliseconds: 800),

                        chartLegendSpacing: 20,
                        chartRadius: 100,
                        // colorList: ,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 20,

                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: false,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: const AppText(
                        "Property Cities",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Center(
                      child: PieChart(
                        dataMap: graphData!.propertyCityStatsMap,
                        animationDuration: Duration(milliseconds: 800),

                        chartLegendSpacing: 20,
                        chartRadius: 100,
                        // colorList: ,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 20,

                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: false,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
