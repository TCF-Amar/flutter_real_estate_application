// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitDetailResponse _$VisitDetailResponseFromJson(Map<String, dynamic> json) =>
    VisitDetailResponse(
      status: json['status'] as bool,
      data: json['data'] == null
          ? null
          : VisitData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VisitDetailResponseToJson(
  VisitDetailResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'data': instance.data?.toJson(),
};

VisitData _$VisitDataFromJson(Map<String, dynamic> json) => VisitData(
  id: (json['id'] as num).toInt(),
  fullName: json['full_name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  preferredDate: json['preferred_date'] as String?,
  preferredDateFormatted: json['preferred_date_formatted'] as String?,
  timeSlotFrom: json['time_slot_from'] as String?,
  timeSlotTo: json['time_slot_to'] as String?,
  timeSlotFormatted: json['time_slot_formatted'] as String?,
  visitingWith: json['visiting_with'] as String?,
  visitingWithLabel: json['visiting_with_label'] as String?,
  message: json['message'] as String?,
  status: json['status'] as String?,
  statusLabel: json['status_label'] as String?,
  canCancel: json['can_cancel'] as bool?,
  canReschedule: json['can_reschedule'] as bool?,
  cancellationReason: json['cancellation_reason'] as String?,
  finalAmount: toDouble(json['final_amount']),
  formattedFinalAmount: json['formatted_final_amount'] as String?,
  agentNotes: json['agent_notes'] as String?,
  confirmedAt: json['confirmed_at'] as String?,
  contactPerson: json['contact_person'] == null
      ? null
      : ContactPerson.fromJson(json['contact_person'] as Map<String, dynamic>),
  agent: json['agent'] == null
      ? null
      : Agent.fromJson(json['agent'] as Map<String, dynamic>),
  developer: json['developer'],
  property: json['property'] == null
      ? null
      : VisitProperty.fromJson(json['property'] as Map<String, dynamic>),
  unit: json['unit'],
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$VisitDataToJson(VisitData instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'email': instance.email,
  'phone': instance.phone,
  'preferred_date': instance.preferredDate,
  'preferred_date_formatted': instance.preferredDateFormatted,
  'time_slot_from': instance.timeSlotFrom,
  'time_slot_to': instance.timeSlotTo,
  'time_slot_formatted': instance.timeSlotFormatted,
  'visiting_with': instance.visitingWith,
  'visiting_with_label': instance.visitingWithLabel,
  'message': instance.message,
  'status': instance.status,
  'status_label': instance.statusLabel,
  'can_cancel': instance.canCancel,
  'can_reschedule': instance.canReschedule,
  'cancellation_reason': instance.cancellationReason,
  'final_amount': instance.finalAmount,
  'formatted_final_amount': instance.formattedFinalAmount,
  'agent_notes': instance.agentNotes,
  'confirmed_at': instance.confirmedAt,
  'contact_person': instance.contactPerson?.toJson(),
  'agent': instance.agent?.toJson(),
  'developer': instance.developer,
  'property': instance.property?.toJson(),
  'unit': instance.unit,
  'created_at': instance.createdAt,
};

ContactPerson _$ContactPersonFromJson(Map<String, dynamic> json) =>
    ContactPerson(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ContactPersonToJson(ContactPerson instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
    };

Agent _$AgentFromJson(Map<String, dynamic> json) => Agent(
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
);

Map<String, dynamic> _$AgentToJson(Agent instance) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
};

VisitProperty _$VisitPropertyFromJson(Map<String, dynamic> json) =>
    VisitProperty(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      propertyCategory: json['property_category'] as String?,
      propertyType: json['property_type'] as String?,
      propertyTypeLabel: json['property_type_label'] as String?,
      status: json['status'] as String?,
      statusLabel: json['status_label'] as String?,
      address: json['address'] as String?,
      location: json['location'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      listingCategory: json['listing_category'] as String?,
      configurationName: json['configuration_name'] as String?,
      price: toDouble(json['price']),
      project: json['project'],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => PropertyImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VisitPropertyToJson(VisitProperty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'property_category': instance.propertyCategory,
      'property_type': instance.propertyType,
      'property_type_label': instance.propertyTypeLabel,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'address': instance.address,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'listing_category': instance.listingCategory,
      'configuration_name': instance.configurationName,
      'price': instance.price,
      'project': instance.project,
      'images': instance.images?.map((e) => e.toJson()).toList(),
    };

PropertyImage _$PropertyImageFromJson(Map<String, dynamic> json) =>
    PropertyImage(
      id: (json['id'] as num?)?.toInt(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$PropertyImageToJson(PropertyImage instance) =>
    <String, dynamic>{'id': instance.id, 'url': instance.url};
