import 'package:real_estate_app/core/utils/safe_parser.dart';

class PropertyFilterModel {
  final bool status;
  final PropertyFilterData data;

  PropertyFilterModel({required this.status, required this.data});

  factory PropertyFilterModel.fromJson(Map<String, dynamic> json) {
    return PropertyFilterModel(
      status: json['status'],
      data: PropertyFilterData.fromJson(json['data']),
    );
  }

  String toPrint() {
    return 'PropertyFilterModel(status: $status, data: ${data.toPrint()})';
  }
}

class PropertyFilterData {
  final List<String> cities;
  final Map<String, String> propertyCategories;
  final Map<String, String> propertyTypes;
  final Map<String, String>? listingCategories;
  final List<BhkOption> bhkOptions;
  final List<String> amenities;
  final List<PriceRangeOption> priceRanges;
  final Map<String, String> sortOptions;

  PropertyFilterData({
    required this.cities,
    required this.propertyCategories,
    required this.propertyTypes,
    this.listingCategories = const {
      "For Buy": "for_buy",
      "For Sale": "for_sale",
      "For Rent": "for_rent",
      "For Tenants": "for_tenants",
    },
    required this.bhkOptions,
    required this.amenities,
    required this.priceRanges,
    required this.sortOptions,
  });

  factory PropertyFilterData.fromJson(Map<String, dynamic> json) {
    return PropertyFilterData(
      cities: List<String>.from(json['cities']),
      propertyCategories: Map<String, String>.from(json['property_categories']),
      propertyTypes: Map<String, String>.from(json['property_types']),
      bhkOptions: (json['bhk_options'] as List)
          .map((e) => BhkOption.fromJson(e))
          .toList(),
      amenities: List<String>.from(json['amenities']),
      priceRanges: (json['price_ranges'] as List)
          .map((e) => PriceRangeOption.fromJson(e))
          .toList(),
      sortOptions: Map<String, String>.from(json['sort_options']),
    );
  }

  String toPrint() {
    return 'PropertyFilterData(cities: $cities, propertyCategories: $propertyCategories, propertyTypes: $propertyTypes, bhkOptions: $bhkOptions, amenities: $amenities, priceRanges: $priceRanges, sortOptions: $sortOptions)';
  }
}

class BhkOption {
  final int value;
  final String label;
  final int count;

  BhkOption({required this.value, required this.label, required this.count});

  factory BhkOption.fromJson(Map<String, dynamic> json) {
    return BhkOption(
      value: toInt(json['value'])!,
      label: toStr(json['label'])!,
      count: toInt(json['count'])!,
    );
  }
}

class PriceRangeOption {
  final int min;
  final int? max;
  final String label;

  PriceRangeOption({required this.min, this.max, required this.label});

  factory PriceRangeOption.fromJson(Map<String, dynamic> json) {
    return PriceRangeOption(
      min: toInt(json['min'])!,
      max: toInt(json['max']),
      label: toStr(json['label'])!,
    );
  }
}
