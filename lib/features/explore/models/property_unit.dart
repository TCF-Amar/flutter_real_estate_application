import 'package:real_estate_app/core/utils/safe_parser.dart';

class PropertyUnit {
  final int id;
  final String? unitNumber;
  final int? bhk;
  final int? bedrooms;
  final int? bathrooms;
  final int? kitchenCount;
  final int? balconyCount;
  final num? carpetAreaSqft;
  final num? builtupAreaSqft;
  final num? superAreaSqft;
  final num? areaSqft;
  final int? floor;
  final String? facing;
  final int? pantry;
  final int? washroom;
  final num? plotLength;
  final num? plotWidth;
  final String? constructionStatus;
  final num? priceCents;
  final num? price;
  final String? formattedPrice;
  final String? status;
  final int? availableUnits;
  final int? totalUnits;
  final String? floorPlanImage;

  const PropertyUnit({
    required this.id,
    this.unitNumber,
    this.bhk,
    this.bedrooms,
    this.bathrooms,
    this.kitchenCount,
    this.balconyCount,
    this.carpetAreaSqft,
    this.builtupAreaSqft,
    this.superAreaSqft,
    this.areaSqft,
    this.floor,
    this.facing,
    this.pantry,
    this.washroom,
    this.plotLength,
    this.plotWidth,
    this.constructionStatus,
    this.priceCents,
    this.price,
    this.formattedPrice,
    this.status,
    this.availableUnits,
    this.totalUnits,
    this.floorPlanImage,
  });

  factory PropertyUnit.fromJson(Map<String, dynamic> json) => PropertyUnit(
    id: toInt(json['id']) ?? 0,
    unitNumber: toStr(json['unit_number']),
    bhk: toInt(json['bhk']),
    bedrooms: toInt(json['bedrooms']),
    bathrooms: toInt(json['bathrooms']),
    kitchenCount: toInt(json['kitchen_count']),
    balconyCount: toInt(json['balcony_count']),
    carpetAreaSqft: toNum(json['carpet_area_sqft']),
    builtupAreaSqft: toNum(json['builtup_area_sqft']),
    superAreaSqft: toNum(json['super_area_sqft']),
    areaSqft: toNum(json['area_sqft']),
    floor: toInt(json['floor']),
    facing: toStr(json['facing']),
    pantry: toInt(json['pantry']),
    washroom: toInt(json['washroom']),
    plotLength: toNum(json['plot_length']),
    plotWidth: toNum(json['plot_width']),
    constructionStatus: toStr(json['construction_status']),
    priceCents: toNum(json['price_cents']),
    price: toNum(json['price']),
    formattedPrice: toStr(json['formatted_price']),
    status: toStr(json['status']),
    availableUnits: toInt(json['available_units']),
    totalUnits: toInt(json['total_units']),
    floorPlanImage: toStr(json['floor_plan_image']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'unit_number': unitNumber,
    'bhk': bhk,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'kitchen_count': kitchenCount,
    'balcony_count': balconyCount,
    'carpet_area_sqft': carpetAreaSqft,
    'builtup_area_sqft': builtupAreaSqft,
    'super_area_sqft': superAreaSqft,
    'area_sqft': areaSqft,
    'floor': floor,
    'facing': facing,
    'pantry': pantry,
    'washroom': washroom,
    'plot_length': plotLength,
    'plot_width': plotWidth,
    'construction_status': constructionStatus,
    'price_cents': priceCents,
    'price': price,
    'formatted_price': formattedPrice,
    'status': status,
    'available_units': availableUnits,
    'total_units': totalUnits,
    'floor_plan_image': floorPlanImage,
  };
}
