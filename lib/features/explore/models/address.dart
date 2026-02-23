import 'package:real_estate_app/core/utils/safe_parser.dart';

class AddressModel {
  final String? line1;
  final String? line2;
  final String? city;
  final String? state;
  final String? country;
  final String? zipcode;
  final String? locality;

  const AddressModel({
    this.line1,
    this.line2,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.locality,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    line1: toStr(json['line1']),
    line2: toStr(json['line2']),
    city: toStr(json['city']),
    state: toStr(json['state']),
    country: toStr(json['country']),
    zipcode: toStr(json['zipcode']),
    locality: toStr(json['locality']),
  );

  Map<String, dynamic> toJson() => {
    'line1': line1,
    'line2': line2,
    'city': city,
    'state': state,
    'country': country,
    'zipcode': zipcode,
    'locality': locality,
  };
}

class Coordinates {
  final double? latitude;
  final double? longitude;

  const Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    latitude: toDouble(json['latitude']),
    longitude: toDouble(json['longitude']),
  );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}
