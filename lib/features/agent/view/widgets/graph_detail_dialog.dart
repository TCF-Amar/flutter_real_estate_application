import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';

const List<Color> _dotColors = [
  Color(0xFF885EFF),
  Color(0xFFB39DFF),
  Color(0xFF5E35B1),
  Color(0xFFFF7043),
  Color(0xFF26C6DA),
  Color(0xFFFFA000),
  Color(0xFF66BB6A),
];

void showGraphDetailDialog(
  BuildContext context,
  Map<String, double> data,
  String title,
) {
  showDialog(
    context: context,
    builder: (context) {
      final entries = data.entries.where((e) => e.key != 'No Data').toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.white,
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: entries.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No data available.'),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final key = entries[index].key;
                    final value = entries[index].value;
                    final color = _dotColors[index % _dotColors.length];
                    final pct = value.toStringAsFixed(1);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              key,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$pct%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
