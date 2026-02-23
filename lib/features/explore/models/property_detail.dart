import 'package:real_estate_app/core/utils/safe_parser.dart';
import 'package:real_estate_app/features/explore/models/address.dart';
import 'package:real_estate_app/features/explore/models/contact.dart';
import 'package:real_estate_app/features/explore/models/project_overview_model.dart';
import 'package:real_estate_app/features/explore/models/property_model.dart';
import 'package:real_estate_app/features/explore/models/property_unit.dart';
import 'package:real_estate_app/features/explore/models/reviews_summary.dart';

class PropertyDetail {
  final int id;
  final String? title;
  final String? configurationName;
  final String? description;
  final String? propertyCategory;
  final String? propertyType;
  final String? propertyMode;
  final String? listingCategory;
  final int? isFeatured;
  final String? status;
  final String? developerName;
  final int? totalFloors;
  final int? yearBuilt;
  final int? totalTowers;
  final int? totalUnits;
  final num? buildingAreaSqft;
  final num? plotAreaSqft;
  final num? plotWidthFt;
  final num? plotLengthFt;
  final String? locality;
  final AddressModel? address;
  final Coordinates? coordinates;
  final num? basePrice;
  final String? priceRange;
  final num? securityDeposit;
  final String? leaseTerm;
  final num? maintenanceCharges;
  final String? maintenancePeriod;
  final ProjectOverviewModel? projectOverview;
  final LatestUpdateModel? latestUpdate;
  final String? furnishingStatus;
  final int? parkingCoveredCount;
  final int? parkingOpenCount;
  final String? possessionDate;
  final String? ageOfProperty;
  final String? formattedPrice;
  final List<PropertyUnit>? units;
  final Media? media;
  final List<Amenity>? amenities;
  final String? bhkList;
  final String? bathroomList;
  final String? areaRange;
  final ReviewsSummary? reviewsSummary;
  final Contact? contact;
  final bool? isFavorited;
  final String? deepLink;
  final ShareData? shareData;

  const PropertyDetail({
    required this.id,
    this.title,
    this.configurationName,
    this.description,
    this.propertyCategory,
    this.propertyType,
    this.propertyMode,
    this.listingCategory,
    this.isFeatured,
    this.status,
    this.developerName,
    this.totalFloors,
    this.yearBuilt,
    this.totalTowers,
    this.totalUnits,
    this.buildingAreaSqft,
    this.plotAreaSqft,
    this.plotWidthFt,
    this.plotLengthFt,
    this.locality,
    this.address,
    this.coordinates,
    this.basePrice,
    this.priceRange,
    this.securityDeposit,
    this.leaseTerm,
    this.maintenanceCharges,
    this.maintenancePeriod,
    this.projectOverview,
    this.latestUpdate,
    this.furnishingStatus,
    this.parkingCoveredCount,
    this.parkingOpenCount,
    this.possessionDate,
    this.ageOfProperty,
    this.formattedPrice,
    this.units,
    this.media,
    this.amenities,
    this.bhkList,
    this.bathroomList,
    this.areaRange,
    this.reviewsSummary,
    this.contact,
    this.isFavorited,
    this.deepLink,
    this.shareData,
  });

  factory PropertyDetail.fromJson(Map<String, dynamic> json) {
    return PropertyDetail(
      id: toInt(json['id'])!,
      title: toStr(json['title']),
      configurationName: toStr(json['configuration_name']),
      description: toStr(json['description']),
      propertyCategory: toStr(json['property_category']),
      propertyType: toStr(json['property_type']),
      propertyMode: toStr(json['property_mode']),
      listingCategory: toStr(json['listing_category']),
      isFeatured: toInt(json['is_featured']),
      status: toStr(json['status']),
      developerName: toStr(json['developer_name']),
      totalFloors: toInt(json['total_floors']),
      yearBuilt: toInt(json['year_built']),
      totalTowers: toInt(json['total_towers']),
      totalUnits: toInt(json['total_units']),
      buildingAreaSqft: toNum(json['building_area_sqft']),
      plotAreaSqft: toNum(json['plot_area_sqft']),
      plotWidthFt: toNum(json['plot_width_ft']),
      plotLengthFt: toNum(json['plot_length_ft']),
      locality: toStr(json['locality']),
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      coordinates: json['coordinates'] != null
          ? Coordinates.fromJson(json['coordinates'])
          : null,
      basePrice: toNum(json['base_price']),
      priceRange: toStr(json['price_range']),
      securityDeposit: toNum(json['security_deposit']),
      leaseTerm: toStr(json['lease_term']),
      maintenanceCharges: toNum(json['maintenance_charges']),
      maintenancePeriod: toStr(json['maintenance_period']),
      projectOverview: json['project_overview'] != null
          ? ProjectOverviewModel.fromJson(json['project_overview'])
          : null,
      latestUpdate: json['latest_update'] != null
          ? LatestUpdateModel.fromJson(json['latest_update'])
          : null,
      furnishingStatus: toStr(json['furnishing_status']),
      parkingCoveredCount: toInt(json['parking_covered_count']),
      parkingOpenCount: toInt(json['parking_open_count']),
      possessionDate: toStr(json['possession_date']),
      ageOfProperty: toStr(json['age_of_property']),
      formattedPrice: toStr(json['formatted_price']),
      units: (json['units'] as List?)
          ?.map((e) => PropertyUnit.fromJson(e))
          .toList(),
      media: json['media'] != null ? Media.fromJson(json['media']) : null,
      amenities: (json['amenities'] as List?)
          ?.map((e) => Amenity.fromJson(e))
          .toList(),
      bhkList: toStr(json['bhk_list']),
      bathroomList: toStr(json['bathroom_list']),
      areaRange: toStr(json['area_range']),
      reviewsSummary: json['reviews_summary'] != null
          ? ReviewsSummary.fromJson(json['reviews_summary'])
          : null,
      contact: json['contact'] != null
          ? Contact.fromJson(json['contact'])
          : null,
      isFavorited:
          json['is_favorited'] == true ||
          json['is_favorited'] == 1 ||
          json['is_favorited']?.toString() == "true",
      deepLink: json['deep_link'] as String?,
      shareData: json['share_data'] != null
          ? ShareData.fromJson(json['share_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'configuration_name': configurationName,
    'description': description,
    'property_category': propertyCategory,
    'property_type': propertyType,
    'property_mode': propertyMode,
    'listing_category': listingCategory,
    'is_featured': isFeatured,
    'status': status,
    'developer_name': developerName,
    'total_floors': totalFloors,
    'year_built': yearBuilt,
    'total_towers': totalTowers,
    'total_units': totalUnits,
    'building_area_sqft': buildingAreaSqft,
    'plot_area_sqft': plotAreaSqft,
    'plot_width_ft': plotWidthFt,
    'plot_length_ft': plotLengthFt,
    'locality': locality,
    'address': address?.toJson(),
    'coordinates': coordinates?.toJson(),
    'base_price': basePrice,
    'price_range': priceRange,
    'security_deposit': securityDeposit,
    'lease_term': leaseTerm,
    'maintenance_charges': maintenanceCharges,
    'maintenance_period': maintenancePeriod,
    'project_overview': projectOverview?.toJson(),
    'latest_update': latestUpdate?.toJson(),
    'furnishing_status': furnishingStatus,
    'parking_covered_count': parkingCoveredCount,
    'parking_open_count': parkingOpenCount,
    'possession_date': possessionDate,
    'age_of_property': ageOfProperty,
    'formatted_price': formattedPrice,
    'units': units?.map((e) => e.toJson()).toList(),
    'media': media?.toJson(),
    'amenities': amenities?.map((e) => e.toJson()).toList(),
    'bhk_list': bhkList,
    'bathroom_list': bathroomList,
    'area_range': areaRange,
    'reviews_summary': reviewsSummary?.toJson(),
    'contact': contact?.toJson(),
    'is_favorited': isFavorited,
    'deep_link': deepLink,
    'share_data': shareData?.toJson(),
  };

  // copyWith
  PropertyDetail copyWith({
    int? id,
    String? title,
    String? configurationName,
    String? description,
    String? propertyCategory,
    String? propertyType,
    String? propertyMode,
    String? listingCategory,
    int? isFeatured,
    String? status,
    String? developerName,
    int? totalFloors,
    int? yearBuilt,
    int? totalTowers,
    int? totalUnits,
    num? buildingAreaSqft,
    num? plotAreaSqft,
    num? plotWidthFt,
    num? plotLengthFt,
    String? locality,
    AddressModel? address,
    Coordinates? coordinates,
    num? basePrice,
    String? priceRange,
    num? securityDeposit,
    String? leaseTerm,
    num? maintenanceCharges,
    String? maintenancePeriod,
    ProjectOverviewModel? projectOverview,
    LatestUpdateModel? latestUpdate,
    String? furnishingStatus,
    int? parkingCoveredCount,
    int? parkingOpenCount,
    String? possessionDate,
    String? ageOfProperty,
    String? formattedPrice,
    List<PropertyUnit>? units,
    Media? media,
    List<Amenity>? amenities,
    String? bhkList,
    String? bathroomList,
    String? areaRange,
    ReviewsSummary? reviewsSummary,
    Contact? contact,
    bool? isFavorited,
    String? deepLink,
    ShareData? shareData,
  }) {
    return PropertyDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      configurationName: configurationName ?? this.configurationName,
      description: description ?? this.description,
      propertyCategory: propertyCategory ?? this.propertyCategory,
      propertyType: propertyType ?? this.propertyType,
      propertyMode: propertyMode ?? this.propertyMode,
      listingCategory: listingCategory ?? this.listingCategory,
      isFeatured: isFeatured ?? this.isFeatured,
      status: status ?? this.status,
      developerName: developerName ?? this.developerName,
      totalFloors: totalFloors ?? this.totalFloors,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      totalTowers: totalTowers ?? this.totalTowers,
      totalUnits: totalUnits ?? this.totalUnits,
      buildingAreaSqft: buildingAreaSqft ?? this.buildingAreaSqft,
      plotAreaSqft: plotAreaSqft ?? this.plotAreaSqft,
      plotWidthFt: plotWidthFt ?? this.plotWidthFt,
      plotLengthFt: plotLengthFt ?? this.plotLengthFt,
      locality: locality ?? this.locality,
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
      basePrice: basePrice ?? this.basePrice,
      priceRange: priceRange ?? this.priceRange,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      leaseTerm: leaseTerm ?? this.leaseTerm,
      maintenanceCharges: maintenanceCharges ?? this.maintenanceCharges,
      maintenancePeriod: maintenancePeriod ?? this.maintenancePeriod,
      projectOverview: projectOverview ?? this.projectOverview,
      latestUpdate: latestUpdate ?? this.latestUpdate,
      furnishingStatus: furnishingStatus ?? this.furnishingStatus,
      parkingCoveredCount: parkingCoveredCount ?? this.parkingCoveredCount,
      parkingOpenCount: parkingOpenCount ?? this.parkingOpenCount,
      possessionDate: possessionDate ?? this.possessionDate,
      ageOfProperty: ageOfProperty ?? this.ageOfProperty,
      formattedPrice: formattedPrice ?? this.formattedPrice,
      units: units ?? this.units,
      media: media ?? this.media,
      amenities: amenities ?? this.amenities,
      bhkList: bhkList ?? this.bhkList,
      bathroomList: bathroomList ?? this.bathroomList,
      areaRange: areaRange ?? this.areaRange,
      reviewsSummary: reviewsSummary ?? this.reviewsSummary,
      contact: contact ?? this.contact,
      isFavorited: isFavorited ?? this.isFavorited,
      deepLink: deepLink ?? this.deepLink,
      shareData: shareData ?? this.shareData,
    );
  }

  bool get isProject => propertyMode == "project";
  bool get isNotCompleted => propertyType == "under_construction";
}
