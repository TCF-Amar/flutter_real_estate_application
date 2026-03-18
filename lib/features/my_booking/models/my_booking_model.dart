import 'package:real_estate_app/features/shared/models/pagination_model.dart';

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  fullyPaid,
  partiallyPaid,
  unknown,
}

BookingStatus bookingStatusFromString(String? s) {
  if (s == null) return BookingStatus.unknown;
  switch (s) {
    case 'pending':
      return BookingStatus.pending;
    case 'confirmed':
      return BookingStatus.confirmed;
    case 'cancelled':
      return BookingStatus.cancelled;
    case 'fully_paid':
      return BookingStatus.fullyPaid;
    case 'partial_paid':
      return BookingStatus.partiallyPaid;
    default:
      return BookingStatus.unknown;
  }
}

String bookingStatusToString(BookingStatus status) {
  switch (status) {
    case BookingStatus.pending:
      return 'pending';
    case BookingStatus.confirmed:
      return 'confirmed';
    case BookingStatus.cancelled:
      return 'cancelled';
    case BookingStatus.fullyPaid:
      return 'fully_paid';
    case BookingStatus.partiallyPaid:
      return 'partial_paid';
    case BookingStatus.unknown:
      return 'unknown';
  }
}

class PropertySummary {
  final int id;
  final String? title;
  final String? address;
  final String? city;
  final String? image;
  final String? propertyType;
  final String? listingCategory;
  final String? propertyCategory;
  final String? specs;

  PropertySummary({
    required this.id,
    this.title,
    this.address,
    this.city,
    this.image,
    this.propertyType,
    this.listingCategory,
    this.propertyCategory,
    this.specs,
  });

  factory PropertySummary.fromJson(Map<String, dynamic> json) {
    return PropertySummary(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      title: json['title'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      image: json['image'] as String?,
      propertyType: json['property_type'] as String?,
      listingCategory: json['listing_category'] as String?,
      propertyCategory: json['property_category'] as String?,
      specs: json['specs'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (title != null) 'title': title,
    if (address != null) 'address': address,
    if (city != null) 'city': city,
    if (image != null) 'image': image,
    if (propertyType != null) 'property_type': propertyType,
    if (listingCategory != null) 'listing_category': listingCategory,
    if (propertyCategory != null) 'property_category': propertyCategory,
    if (specs != null) 'specs': specs,
  };
}

class Booking {
  final int id;
  final String bookingId;
  final String? bookedOn;
  final BookingStatus status;
  final String? paymentStatusLabel;
  final num? totalAmount;
  final num? paidAmount;
  final PropertySummary? property;
  final String? createdAt;
  final String? updatedAt;

  Booking({
    required this.id,
    required this.bookingId,
    this.bookedOn,
    this.status = BookingStatus.unknown,
    this.paymentStatusLabel,
    this.totalAmount,
    this.paidAmount,
    this.property,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      bookingId: json['booking_id'] as String? ?? '',
      bookedOn: json['booked_on'] as String?,
      status: bookingStatusFromString(json['status'] as String?),
      paymentStatusLabel: json['payment_status_label'] as String?,
      totalAmount: json['total_amount'] as num?,
      paidAmount: json['paid_amount'] as num?,
      property:
          json['property'] != null && json['property'] is Map<String, dynamic>
          ? PropertySummary.fromJson(json['property'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'booking_id': bookingId,
      'booked_on': bookedOn,
      'status': bookingStatusToString(status),
      'payment_status_label': paymentStatusLabel,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
    if (property != null) {
      map['property'] = property!.toJson();
    }
    return map;
  }

  num get balance => (totalAmount ?? 0) - (paidAmount ?? 0);

  bool get isFullyPaid =>
      totalAmount != null &&
      paidAmount != null &&
      (paidAmount! >= totalAmount!);
}

class BookingResponse {
  final bool status;
  final BookingData data;

  BookingResponse({required this.data, required this.status});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      status: json['status'] as bool,
      data: BookingData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'data': data.toJson()};
}

class BookingData {
  final List<Booking> bookings;
  final PaginationModel pagination;

  BookingData({required this.bookings, required this.pagination});

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      bookings:
          (json['bookings'] as List<dynamic>?)
              ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <Booking>[],
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': bookings.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}
