import 'package:json_annotation/json_annotation.dart';
import 'package:real_estate_app/core/utils/safe_parser.dart';

part 'visit_detail_response.g.dart';

@JsonSerializable(explicitToJson: true)
class VisitDetailResponse {
  final bool status;
  final VisitData? data;

  VisitDetailResponse({required this.status, this.data});

  factory VisitDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$VisitDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VisitDetailResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VisitData {
  final int id;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? email;
  final String? phone;
  @JsonKey(name: 'preferred_date')
  final String? preferredDate;
  @JsonKey(name: 'preferred_date_formatted')
  final String? preferredDateFormatted;
  @JsonKey(name: 'time_slot_from')
  final String? timeSlotFrom;
  @JsonKey(name: 'time_slot_to')
  final String? timeSlotTo;
  @JsonKey(name: 'time_slot_formatted')
  final String? timeSlotFormatted;
  @JsonKey(name: 'visiting_with')
  final String? visitingWith;
  @JsonKey(name: 'visiting_with_label')
  final String? visitingWithLabel;
  final String? message;
  final String? status;
  @JsonKey(name: 'status_label')
  final String? statusLabel;
  @JsonKey(name: 'can_cancel')
  final bool? canCancel;
  @JsonKey(name: 'can_reschedule')
  final bool? canReschedule;
  @JsonKey(name: 'cancellation_reason')
  final String? cancellationReason;
  @JsonKey(name: 'final_amount', fromJson: toDouble)
  final double? finalAmount;
  @JsonKey(name: 'formatted_final_amount')
  final String? formattedFinalAmount;
  @JsonKey(name: 'agent_notes')
  final String? agentNotes;
  @JsonKey(name: 'confirmed_at')
  final String? confirmedAt;
  @JsonKey(name: 'contact_person')
  final ContactPerson? contactPerson;
  final Agent? agent;
  final dynamic developer;
  final VisitProperty? property;
  final dynamic unit;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  VisitData({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.preferredDate,
    this.preferredDateFormatted,
    this.timeSlotFrom,
    this.timeSlotTo,
    this.timeSlotFormatted,
    this.visitingWith,
    this.visitingWithLabel,
    this.message,
    this.status,
    this.statusLabel,
    this.canCancel,
    this.canReschedule,
    this.cancellationReason,
    this.finalAmount,
    this.formattedFinalAmount,
    this.agentNotes,
    this.confirmedAt,
    this.contactPerson,
    this.agent,
    this.developer,
    this.property,
    this.unit,
    this.createdAt,
  });

  factory VisitData.fromJson(Map<String, dynamic> json) =>
      _$VisitDataFromJson(json);

  Map<String, dynamic> toJson() => _$VisitDataToJson(this);
}

@JsonSerializable()
class ContactPerson {
  final String? name;
  final String? phone;
  final String? email;

  ContactPerson({this.name, this.phone, this.email});

  factory ContactPerson.fromJson(Map<String, dynamic> json) =>
      _$ContactPersonFromJson(json);

  Map<String, dynamic> toJson() => _$ContactPersonToJson(this);
}

@JsonSerializable()
class Agent {
  final String? name;
  final String? phone;
  final String? email;

  Agent({this.name, this.phone, this.email});

  factory Agent.fromJson(Map<String, dynamic> json) => _$AgentFromJson(json);

  Map<String, dynamic> toJson() => _$AgentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VisitProperty {
  final int? id;
  final String? title;
  final String? description;
  @JsonKey(name: 'property_category')
  final String? propertyCategory;
  @JsonKey(name: 'property_type')
  final String? propertyType;
  @JsonKey(name: 'property_type_label')
  final String? propertyTypeLabel;
  final String? status;
  @JsonKey(name: 'status_label')
  final String? statusLabel;
  final String? address;
  final String? location;
  final String? latitude;
  final String? longitude;
  @JsonKey(name: 'listing_category')
  final String? listingCategory;
  @JsonKey(name: 'configuration_name')
  final String? configurationName;
  @JsonKey(fromJson: toDouble)
  final double? price;
  final dynamic project;
  final List<PropertyImage>? images;

  VisitProperty({
    this.id,
    this.title,
    this.description,
    this.propertyCategory,
    this.propertyType,
    this.propertyTypeLabel,
    this.status,
    this.statusLabel,
    this.address,
    this.location,
    this.latitude,
    this.longitude,
    this.listingCategory,
    this.configurationName,
    this.price,
    this.project,
    this.images,
  });

  factory VisitProperty.fromJson(Map<String, dynamic> json) =>
      _$VisitPropertyFromJson(json);

  Map<String, dynamic> toJson() => _$VisitPropertyToJson(this);
}

@JsonSerializable()
class PropertyImage {
  final int? id;
  final String? url;

  PropertyImage({this.id, this.url});

  factory PropertyImage.fromJson(Map<String, dynamic> json) =>
      _$PropertyImageFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyImageToJson(this);
}
