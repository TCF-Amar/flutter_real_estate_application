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

  Map<String, double> _safeMapDetails(List<GraphStat> stats) {
    final map = <String, double>{};

    for (final stat in stats) {
      if (stat.percentage > 0) {
        map[stat.label.isEmpty ? 'Unknown' : stat.label] = stat.percentage
            .toDouble();
      }
    }

    // prevent empty map crash
    if (map.isEmpty) {
      map["No Data"] = 0.0;
    }

    return map;
  }

  Map<String, double> _safeMap(List<GraphStat> stats) {
    if (stats.isEmpty) {
      return {"No Data": 0.0};
    }

    final filtered = stats.where((e) => e.percentage > 0).toList();

    if (filtered.isEmpty) {
      return {"No Data": 0.0};
    }

    filtered.sort((a, b) => b.percentage.compareTo(a.percentage));

    final map = <String, double>{};

    if (filtered.length <= 5) {
      for (final stat in filtered) {
        map["${stat.percentage}% ${stat.label.isEmpty ? 'Unknown' : stat.label}"] =
            stat.percentage.toDouble();
      }
      return map;
    }

    final topItems = filtered.take(4).toList();

    for (final stat in topItems) {
      map["${stat.percentage}% ${stat.label.isEmpty ? 'Unknown' : stat.label}"] =
          stat.percentage.toDouble();
    }

    final remaining = filtered.skip(4);

    int remainingCount = 0;
    double remainingPercentage = 0;

    for (final stat in remaining) {
      remainingCount++;
      remainingPercentage += stat.percentage.toDouble();
    }

    map["+$remainingCount Others"] = remainingPercentage;

    return map;
  }

  // list to map for pie chart
  Map<String, double> get propertyTypeStatsMap => _safeMap(propertyTypeStats);
  Map<String, double> get propertyTypeStatsDetails =>
      _safeMapDetails(propertyTypeStats);

  Map<String, double> get propertyStatusStatsMap =>
      _safeMap(propertyStatusStats);
  Map<String, double> get propertyStatusStatsDetails =>
      _safeMapDetails(propertyStatusStats);

  Map<String, double> get propertyCityStatsMap => _safeMap(propertyCityStats);
  Map<String, double> get propertyCityStatsDetails =>
      _safeMapDetails(propertyCityStats);
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
