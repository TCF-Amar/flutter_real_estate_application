import 'package:real_estate_app/features/property/models/property_detail_model.dart';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';

class VisitConfirmationModel {
  final PropertyDetail property;
  final String name;
  final String email;
  final String phone;
  final String date;
  final String apiDate;
  final String startTime;
  final String apiStartTime;
  final String endTime;
  final String apiEndTime;
  final String message;
  final String visitWith;

  VisitConfirmationModel({
    required this.property,
    required this.name,
    required this.email,
    required this.phone,
    required this.date,
    required this.apiDate,
    required this.startTime,
    required this.apiStartTime,
    required this.endTime,
    required this.apiEndTime,
    required this.message,
    required this.visitWith,
  });
}

class VisitConfirmRequestModel {
  final int propertyId;
  final int? unitId;
  final String name;
  final String email;
  final String phone;
  final String countryCode;
  final String preferredDate;
  final String timeSlotFrom;
  final String timeSlotTo;
  final String visitingWith;
  final String message;

  VisitConfirmRequestModel({
    required this.propertyId,
    this.unitId,
    required this.name,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.preferredDate,
    required this.timeSlotFrom,
    required this.timeSlotTo,
    required this.visitingWith,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "property_id": propertyId,
      if (unitId != null) "unit_id": unitId,
      "full_name": name,
      "email": email,
      "phone": phone,
      "country_code": countryCode,
      "preferred_date": preferredDate,
      "time_slot_from": timeSlotFrom,
      "time_slot_to": timeSlotTo,
      "visiting_with": visitingWith,
      "message": message,
    };
  }
}

class VisitResponse {
  final bool status;
  // final String message;
  final List<VisitResponseData> data;
  final PaginationModel pagination;

  VisitResponse({
    required this.status,
    // required this.message,
    required this.data,
    required this.pagination,
  });

  factory VisitResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataJson = json['data'];
    List<VisitResponseData> dataList = [];
    PaginationModel? pagination;

    if (dataJson is Map<String, dynamic>) {
      final dynamic visits = dataJson['visits'];
      if (visits is List) {
        dataList = visits
            .map((e) => VisitResponseData.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (dataJson.containsKey('pagination')) {
        pagination = PaginationModel.fromJson(
          dataJson['pagination'] as Map<String, dynamic>,
        );
      }
    }

    return VisitResponse(
      status: json['status'] as bool? ?? false,
      data: dataList,
      pagination: pagination ??
          PaginationModel.fromJson(
            (json['pagination'] as Map<String, dynamic>?) ?? {},
          ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class VisitResponseData {
  final int id;
  final PProperty property;
  final String unit;
  final String? preferredDate;
  final String? preferredDateFormatted;
  final String? timeSlot;
  final String? timeSlotFormatted;
  final String status;
  final String statusLabel;
  final bool canCancel;
  final bool canReschedule;
  final double? finalAmount;
  final String? formattedFinalAmount;
  final String? createdAt;

  VisitResponseData({
    required this.id,
    required this.property,
    required this.unit,
    required this.preferredDate,
    required this.preferredDateFormatted,
    required this.timeSlot,
    required this.timeSlotFormatted,
    required this.status,
    required this.statusLabel,
    required this.canCancel,
    required this.canReschedule,
    required this.finalAmount,
    required this.formattedFinalAmount,
    required this.createdAt,
  }); // ISO datetime string

  factory VisitResponseData.fromJson(Map<String, dynamic> json) =>
      VisitResponseData(
        id: json['id'] as int,
        property: PProperty.fromJson(json['property'] as Map<String, dynamic>),
        unit: json['unit'] as String? ?? '',
        preferredDate: json['preferred_date'] as String?,
        preferredDateFormatted: json['preferred_date_formatted'] as String?,
        timeSlot: json['time_slot'] as String?,
        timeSlotFormatted: json['time_slot_formatted'] as String?,
        status: json['status'] as String? ?? '',
        statusLabel: json['status_label'] as String? ?? '',
        canCancel: json['can_cancel'] as bool? ?? false,
        canReschedule: json['can_reschedule'] as bool? ?? false,
        finalAmount: json['final_amount'] as double?,
        formattedFinalAmount: json['formatted_final_amount'] as String?,
        createdAt: json['created_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'property': property.toJson(),
    'unit': unit,
    'preferred_date': preferredDate,
    'preferred_date_formatted': preferredDateFormatted,
    'time_slot': timeSlot,
    'time_slot_formatted': timeSlotFormatted,
    'status': status,
    'status_label': statusLabel,
    'can_cancel': canCancel,
    'can_reschedule': canReschedule,
    'final_amount': finalAmount,
    'formatted_final_amount': formattedFinalAmount,
    'created_at': createdAt,
  };
}

class PProperty {
  final int id;
  final String title;
  final String? location;
  final String? address;
  final String? thumbnail;
  final String status;
  final String statusLabel;
  final String propertyType;
  final String propertyTypeLabel;

  PProperty({
    required this.id,
    required this.title,
    this.location,
    this.address,
    this.thumbnail,
    required this.status,
    required this.statusLabel,
    required this.propertyType,
    required this.propertyTypeLabel,
  });

  factory PProperty.fromJson(Map<String, dynamic> json) => PProperty(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    location: json['location'] as String?,
    address: json['address'] as String?,
    thumbnail: json['thumbnail'] as String?,
    status: json['status'] as String? ?? '',
    statusLabel: json['status_label'] as String? ?? '',
    propertyType: json['property_type'] as String? ?? '',
    propertyTypeLabel: json['property_type_label'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'location': location,
    'address': address,
    'thumbnail': thumbnail,
    'status': status,
    'status_label': statusLabel,
    'property_type': propertyType,
    'property_type_label': propertyTypeLabel,
  };
}
