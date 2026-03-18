import 'package:real_estate_app/core/utils/safe_parser.dart';

class BookingDetailResponse {
  final bool? status;
  final BookingDetailsData? data;

  BookingDetailResponse({this.status, this.data});

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailResponse(
      status: json['status'] as bool?,
      data: json['data'] is Map<String, dynamic>
          ? BookingDetailsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    if (data != null) 'data': data!.toJson(),
  };
}

class BookingDetailsData {
  final BookingSummary bookingSummary;
  final BookedPropertyDetail propertyDetail;
  final ProjectOverview? projectOverview;
  final UpdateItem? latestUpdate;
  final SiteVisitSummary? siteVisitSummary;
  final OwnerDetail? ownerDetail;
  final PaymentTracker? paymentTracker;

  BookingDetailsData({
    required this.bookingSummary,
    required this.propertyDetail,
    this.projectOverview,
    this.latestUpdate,
    this.siteVisitSummary,
    this.ownerDetail,
    this.paymentTracker,
  });

  factory BookingDetailsData.fromJson(Map<String, dynamic> json) {
    return BookingDetailsData(
      bookingSummary: BookingSummary.fromJson(
        json['booking_summary'] as Map<String, dynamic>? ?? {},
      ),
      propertyDetail: BookedPropertyDetail.fromJson(
        json['property_detail'] as Map<String, dynamic>? ?? {},
      ),
      projectOverview: json['project_overview'] is Map<String, dynamic>
          ? ProjectOverview.fromJson(
              json['project_overview'] as Map<String, dynamic>,
            )
          : null,
      latestUpdate: json['latest_update'] is Map<String, dynamic>
          ? UpdateItem.fromJson(json['latest_update'] as Map<String, dynamic>)
          : null,
      siteVisitSummary: json['site_visit_summary'] is Map<String, dynamic>
          ? SiteVisitSummary.fromJson(
              json['site_visit_summary'] as Map<String, dynamic>,
            )
          : null,
      ownerDetail: json['owner_detail'] is Map<String, dynamic>
          ? OwnerDetail.fromJson(json['owner_detail'] as Map<String, dynamic>)
          : null,
      paymentTracker: json['payment_tracker'] is Map<String, dynamic>
          ? PaymentTracker.fromJson(
              json['payment_tracker'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'booking_summary': bookingSummary.toJson(),
    'property_detail': propertyDetail.toJson(),
    if (projectOverview != null) 'project_overview': projectOverview!.toJson(),
    if (latestUpdate != null) 'latest_update': latestUpdate!.toJson(),
    if (siteVisitSummary != null)
      'site_visit_summary': siteVisitSummary!.toJson(),
    if (ownerDetail != null) 'owner_detail': ownerDetail!.toJson(),
    if (paymentTracker != null) 'payment_tracker': paymentTracker!.toJson(),
  };
}

class BookingDetails {
  final BookingSummary bookingSummary;
  final BookedPropertyDetail propertyDetail;
  final ProjectOverview? projectOverview;
  final UpdateItem? latestUpdate;
  final SiteVisitSummary? siteVisitSummary;
  final OwnerDetail? ownerDetail;
  final PaymentTracker? paymentTracker;

  BookingDetails({
    required this.bookingSummary,
    required this.propertyDetail,
    this.projectOverview,
    this.latestUpdate,
    this.siteVisitSummary,
    this.ownerDetail,
    this.paymentTracker,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw FormatException('BookingDetails: expected "data" object');
    }

    return BookingDetails(
      bookingSummary: BookingSummary.fromJson(
        data['booking_summary'] as Map<String, dynamic>? ?? {},
      ),
      propertyDetail: BookedPropertyDetail.fromJson(
        data['property_detail'] as Map<String, dynamic>? ?? {},
      ),
      projectOverview: data['project_overview'] is Map<String, dynamic>
          ? ProjectOverview.fromJson(
              data['project_overview'] as Map<String, dynamic>,
            )
          : null,
      latestUpdate: data['latest_update'] is Map<String, dynamic>
          ? UpdateItem.fromJson(data['latest_update'] as Map<String, dynamic>)
          : null,
      siteVisitSummary: data['site_visit_summary'] is Map<String, dynamic>
          ? SiteVisitSummary.fromJson(
              data['site_visit_summary'] as Map<String, dynamic>,
            )
          : null,
      ownerDetail: data['owner_detail'] is Map<String, dynamic>
          ? OwnerDetail.fromJson(data['owner_detail'] as Map<String, dynamic>)
          : null,
      paymentTracker: data['payment_tracker'] is Map<String, dynamic>
          ? PaymentTracker.fromJson(
              data['payment_tracker'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'booking_summary': bookingSummary.toJson(),
    'property_detail': propertyDetail.toJson(),
    if (projectOverview != null) 'project_overview': projectOverview!.toJson(),
    if (latestUpdate != null) 'latest_update': latestUpdate!.toJson(),
    if (siteVisitSummary != null)
      'site_visit_summary': siteVisitSummary!.toJson(),
    if (ownerDetail != null) 'owner_detail': ownerDetail!.toJson(),
    if (paymentTracker != null) 'payment_tracker': paymentTracker!.toJson(),
  };
}

/* --- BookingSummary --- */
class BookingSummary {
  final String bookingId;
  final String? bookedOn;
  final String? paymentType;
  final String? bookingType;
  final num? totalAmount;
  final num? paidAmount;
  final num? remainingAmount;
  final String? status;
  final String? nextPaymentDue;
  final String? nextPaymentLabel;
  final String? percentageComplete;
  final double? percentage;
  final int? remainingLeasePayments;
  final String? downloadReceiptUrl;
  final String? viewDocumentUrl;

  BookingSummary({
    required this.bookingId,
    this.bookedOn,
    this.paymentType,
    this.bookingType,
    this.totalAmount,
    this.paidAmount,
    this.remainingAmount,
    this.status,
    this.nextPaymentDue,
    this.nextPaymentLabel,
    this.percentageComplete,
    this.percentage,
    this.remainingLeasePayments,
    this.downloadReceiptUrl,
    this.viewDocumentUrl,
  });

  factory BookingSummary.fromJson(Map<String, dynamic> json) {
    return BookingSummary(
      bookingId: json['booking_id'] as String? ?? '',
      bookedOn: json['booked_on'] as String?,
      paymentType: json['payment_type'] as String?,
      bookingType: json['booking_type'] as String?,
      totalAmount: toNum(json['total_amount']),
      paidAmount: toNum(json['paid_amount']),
      remainingAmount: toNum(json['remaining_amount']),
      status: json['status'] as String?,
      nextPaymentDue: json['next_payment_due'] as String?,
      nextPaymentLabel: json['next_payment_label'] as String?,
      percentageComplete: json['percentage_complete'] as String?,
      percentage: toDouble(json['percentage']),
      remainingLeasePayments: toInt(json['remaining_lease_payments']),
      downloadReceiptUrl: json['download_receipt_url'] as String?,
      viewDocumentUrl: json['view_document_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'booking_id': bookingId,
    if (bookedOn != null) 'booked_on': bookedOn,
    if (paymentType != null) 'payment_type': paymentType,
    if (bookingType != null) 'booking_type': bookingType,
    if (totalAmount != null) 'total_amount': totalAmount,
    if (paidAmount != null) 'paid_amount': paidAmount,
    if (remainingAmount != null) 'remaining_amount': remainingAmount,
    if (status != null) 'status': status,
    if (nextPaymentDue != null) 'next_payment_due': nextPaymentDue,
    if (nextPaymentLabel != null) 'next_payment_label': nextPaymentLabel,
    if (percentageComplete != null) 'percentage_complete': percentageComplete,
    if (percentage != null) 'percentage': percentage,
    if (remainingLeasePayments != null)
      'remaining_lease_payments': remainingLeasePayments,
    if (downloadReceiptUrl != null) 'download_receipt_url': downloadReceiptUrl,
    if (viewDocumentUrl != null) 'view_document_url': viewDocumentUrl,
  };

  num get balance => (totalAmount ?? 0) - (paidAmount ?? 0);
  bool get isFullyPaid =>
      (totalAmount != null &&
      paidAmount != null &&
      paidAmount! >= totalAmount!);
}

/* --- PropertyDetail --- */
class BookedPropertyDetail {
  final int id;
  final String? title;
  final String? propertyCategory;
  final String? propertyType;
  final bool? isFeatured;
  final String? address;
  final List<MediaItem> images;
  final List<DocumentItem> documents;
  final UnitDetails? unitDetails;

  BookedPropertyDetail({
    required this.id,
    this.title,
    this.propertyCategory,
    this.propertyType,
    this.isFeatured,
    this.address,
    List<MediaItem>? images,
    List<DocumentItem>? documents,
    this.unitDetails,
  }) : images = images ?? [],
       documents = documents ?? [];

  factory BookedPropertyDetail.fromJson(Map<String, dynamic> json) {
    return BookedPropertyDetail(
      id: toInt(json['id'])!,
      title: json['title'] as String?,
      propertyCategory: json['property_category'] as String?,
      propertyType: json['property_type'] as String?,
      isFeatured: json['is_featured'] is bool
          ? json['is_featured'] as bool
          : null,
      address: json['address'] as String?,
      images: (json['images'] is List)
          ? (json['images'] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => MediaItem.fromJson(e))
                .toList()
          : [],
      documents: (json['documents'] is List)
          ? (json['documents'] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => DocumentItem.fromJson(e))
                .toList()
          : [],
      unitDetails: json['unit_details'] is Map<String, dynamic>
          ? UnitDetails.fromJson(json['unit_details'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (title != null) 'title': title,
    if (propertyCategory != null) 'property_category': propertyCategory,
    if (propertyType != null) 'property_type': propertyType,
    if (isFeatured != null) 'is_featured': isFeatured,
    if (address != null) 'address': address,
    if (images.isNotEmpty) 'images': images.map((e) => e.toJson()).toList(),
    if (documents.isNotEmpty)
      'documents': documents.map((e) => e.toJson()).toList(),
    if (unitDetails != null) 'unit_details': unitDetails!.toJson(),
  };

  bool get isUnderConstruction => propertyType == "under_construction";

  /* --- MediaItem --- */
}

class MediaItem {
  final int? id;
  final String? url;

  MediaItem({this.id, this.url});

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(id: toInt(json['id']), url: json['url'] as String?);
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (url != null) 'url': url,
  };
}

class DocumentItem {
  final int? id;
  final String? url;
  final String? fileType;
  final String? documentType;

  DocumentItem({this.id, this.url, this.fileType, this.documentType});

  factory DocumentItem.fromJson(Map<String, dynamic> json) {
    return DocumentItem(
      id: toInt(json['id']),
      url: json['url'] as String?,
      fileType: json['file_type'] as String?,
      documentType: json['document_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (url != null) 'url': url,
    if (fileType != null) 'file_type': fileType,
    if (documentType != null) 'document_type': documentType,
  };
}

class UnitDetails {
  final String? unitNumber;
  final int? bhk;
  final String? size;
  final String? block;
  final String? flat;
  final String? floor;

  UnitDetails({
    this.unitNumber,
    this.bhk,
    this.size,
    this.block,
    this.flat,
    this.floor,
  });

  factory UnitDetails.fromJson(Map<String, dynamic> json) {
    return UnitDetails(
      unitNumber: json['unit_number'] as String?,
      bhk: toInt(json['bhk']),
      size: json['size'] as String?,
      block: json['block'] as String?,
      flat: json['flat'] as String?,
      floor: json['floor'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (unitNumber != null) 'unit_number': unitNumber,
    if (bhk != null) 'bhk': bhk,
    if (size != null) 'size': size,
    if (block != null) 'block': block,
    if (flat != null) 'flat': flat,
    if (floor != null) 'floor': floor,
  };
}

/* --- ProjectOverview --- */
class ProjectOverview {
  final String? percentageComplete;
  final int? progressValue;
  final String? status;
  final String? possessionDate;
  final List<ProjectStage> stages;

  ProjectOverview({
    this.percentageComplete,
    this.progressValue,
    this.status,
    this.possessionDate,
    List<ProjectStage>? stages,
  }) : stages = stages ?? [];

  factory ProjectOverview.fromJson(Map<String, dynamic> json) {
    return ProjectOverview(
      percentageComplete: json['percentage_complete'] as String?,
      progressValue: toInt(json['progress_value']),
      status: json['status'] as String?,
      possessionDate: json['possession_date'] as String?,
      stages: (json['stages'] is List)
          ? (json['stages'] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => ProjectStage.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    if (percentageComplete != null) 'percentage_complete': percentageComplete,
    if (progressValue != null) 'progress_value': progressValue,
    if (status != null) 'status': status,
    if (possessionDate != null) 'possession_date': possessionDate,
    if (stages.isNotEmpty) 'stages': stages.map((e) => e.toJson()).toList(),
  };
}

class ProjectStage {
  final String? name;
  final String? status;

  ProjectStage({this.name, this.status});

  factory ProjectStage.fromJson(Map<String, dynamic> json) {
    return ProjectStage(
      name: json['name'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (status != null) 'status': status,
  };
}

/* --- UpdateItem (latest_update) --- */
class UpdateItem {
  final int? id;
  final String? date;
  final String? title;
  final String? description;
  final List<MediaItem> images;

  UpdateItem({
    this.id,
    this.date,
    this.title,
    this.description,
    List<MediaItem>? images,
  }) : images = images ?? [];

  factory UpdateItem.fromJson(Map<String, dynamic> json) {
    return UpdateItem(
      id: toInt(json['id']),
      date: json['date'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      images: (json['images'] is List)
          ? (json['images'] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => MediaItem.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (date != null) 'date': date,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (images.isNotEmpty) 'images': images.map((e) => e.toJson()).toList(),
  };
}

/* --- SiteVisitSummary --- */
class SiteVisitSummary {
  final String? agentName;
  final String? agentPhone;
  final String? date;
  final String? time;
  final String? completedOn;
  final String? feedback;

  SiteVisitSummary({
    this.agentName,
    this.agentPhone,
    this.date,
    this.time,
    this.completedOn,
    this.feedback,
  });

  factory SiteVisitSummary.fromJson(Map<String, dynamic> json) {
    return SiteVisitSummary(
      agentName: json['agent_name'] as String?,
      agentPhone: json['agent_phone'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      completedOn: json['completed_on'] as String?,
      feedback: json['feedback'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (agentName != null) 'agent_name': agentName,
    if (agentPhone != null) 'agent_phone': agentPhone,
    if (date != null) 'date': date,
    if (time != null) 'time': time,
    if (completedOn != null) 'completed_on': completedOn,
    if (feedback != null) 'feedback': feedback,
  };
}

/* --- OwnerDetail --- */
class OwnerDetail {
  final String? type;
  final int? agentId;
  final String? name;
  final String? image;
  final String? description;
  final int? propertiesCount;
  final String? experience;
  final double? rating;
  final int? reviewsCount;

  OwnerDetail({
    this.type,
    this.agentId,
    this.name,
    this.image,
    this.description,
    this.propertiesCount,
    this.experience,
    this.rating,
    this.reviewsCount,
  });

  factory OwnerDetail.fromJson(Map<String, dynamic> json) {
    return OwnerDetail(
      type: json['type'] as String?,
      agentId: toInt(json['agent_id']),
      name: json['name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      propertiesCount: toInt(json['properties_count']),
      experience: json['experience'] as String?,
      rating: toDouble(json['rating']),
      reviewsCount: toInt(json['reviews_count']),
    );
  }

  Map<String, dynamic> toJson() => {
    if (type != null) 'type': type,
    if (agentId != null) 'agent_id': agentId,
    if (name != null) 'name': name,
    if (image != null) 'image': image,
    if (description != null) 'description': description,
    if (propertiesCount != null) 'properties_count': propertiesCount,
    if (experience != null) 'experience': experience,
    if (rating != null) 'rating': rating,
    if (reviewsCount != null) 'reviews_count': reviewsCount,
  };
}

/* --- PaymentTracker --- */
class PaymentTracker {
  final String? type;
  final List<PaymentEvent> events;

  PaymentTracker({this.type, List<PaymentEvent>? events})
    : events = events ?? [];

  factory PaymentTracker.fromJson(Map<String, dynamic> json) {
    return PaymentTracker(
      type: json['type'] as String?,
      events: (json['events'] is List)
          ? (json['events'] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => PaymentEvent.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    if (type != null) 'type': type,
    if (events.isNotEmpty) 'events': events.map((e) => e.toJson()).toList(),
  };
}

class PaymentEvent {
  final int? id;
  final String? label;
  final num? amount;
  final String? date;
  final String? status;
  final String? receiptUrl;

  PaymentEvent({
    this.id,
    this.label,
    this.amount,
    this.date,
    this.status,
    this.receiptUrl,
  });

  factory PaymentEvent.fromJson(Map<String, dynamic> json) {
    return PaymentEvent(
      id: toInt(json['id']),
      label: json['label'] as String?,
      amount: toNum(json['amount']),
      date: json['date'] as String?,
      status: json['status'] as String?,
      receiptUrl: json['receipt_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (label != null) 'label': label,
    if (amount != null) 'amount': amount,
    if (date != null) 'date': date,
    if (status != null) 'status': status,
    if (receiptUrl != null) 'receipt_url': receiptUrl,
  };
}
