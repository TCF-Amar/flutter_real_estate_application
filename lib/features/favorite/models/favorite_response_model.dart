import 'package:real_estate_app/features/favorite/models/favorite_property.dart';

class FavoriteResponseModel {
  final bool status;
  final FavoriteResponseData data;

  FavoriteResponseModel({required this.status, required this.data});

  factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteResponseModel(
      status: json['status'] as bool? ?? false,
      data: FavoriteResponseData.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'data': data.toJson()};
}

class FavoriteResponseData {
  final List<FavoriteProperty> property;

  FavoriteResponseData({required this.property});

  factory FavoriteResponseData.fromJson(Map<String, dynamic> json) {
    final rawList = json['saved_properties'];
    return FavoriteResponseData(
      property: rawList == null
          ? []
          : List<FavoriteProperty>.from(
              (rawList as List<dynamic>).map(
                (x) => FavoriteProperty.fromJson(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    'property': property.map((x) => x.toJson()).toList(),
  };
}
