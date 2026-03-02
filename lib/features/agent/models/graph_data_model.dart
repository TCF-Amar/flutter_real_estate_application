class GraphDataModel {
  final List<GraphStat> propertyTypeStats;
  final List<GraphStat> propertyStatusStats;
  final List<GraphStat> propertyCityStats;

  GraphDataModel({
    required this.propertyTypeStats,
    required this.propertyStatusStats,
    required this.propertyCityStats,
  });

  factory GraphDataModel.fromJson(Map<String, dynamic> json) {
    return GraphDataModel(
      propertyTypeStats: (json['property_type_stats'] as List? ?? [])
          .map((e) => GraphStat.fromJson(e))
          .toList(),
      propertyStatusStats: (json['property_status_stats'] as List? ?? [])
          .map((e) => GraphStat.fromJson(e))
          .toList(),
      propertyCityStats: (json['property_city_stats'] as List? ?? [])
          .map((e) => GraphStat.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property_type_stats': propertyTypeStats.map((e) => e.toJson()).toList(),
      'property_status_stats': propertyStatusStats
          .map((e) => e.toJson())
          .toList(),
      'property_city_stats': propertyCityStats.map((e) => e.toJson()).toList(),
    };
  }

  // list to map for pie chart
  Map<String, double> get propertyTypeStatsMap {
    return {
      for (var stat in propertyTypeStats)
        if (stat.percentage > 0)
          "${stat.percentage}% ${stat.label}": stat.percentage.toDouble(),
    };
  }

  Map<String, double> get propertyStatusStatsMap {
    return {
      for (var stat in propertyStatusStats)
        if (stat.percentage > 0)
          "${stat.percentage}% ${stat.label.isEmpty ? 'Unknown' : stat.label}":
              stat.percentage.toDouble(),
    };
  }

  Map<String, double> get propertyCityStatsMap {
    return {
      for (var stat in propertyCityStats)
        if (stat.percentage > 0)
          "${stat.percentage}% ${stat.label.isEmpty ? 'Unknown' : stat.label}":
              stat.percentage.toDouble(),
    };
  }
}

class GraphStat {
  final String label;
  final int count;
  final int percentage;

  GraphStat({
    required this.label,
    required this.count,
    required this.percentage,
  });

  factory GraphStat.fromJson(Map<String, dynamic> json) {
    return GraphStat(
      label: json['label'] ?? '',
      count: json['count'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'count': count, 'percentage': percentage};
  }
}
