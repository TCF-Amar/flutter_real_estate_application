import 'package:real_estate_app/features/agent/models/agent_model.dart';
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
}

class FavoriteResponseData {
  final List<FavoriteProperty> properties;
  final List<AgentModel> agents;
  final List<dynamic> developers;

  FavoriteResponseData({
    required this.properties,
    required this.agents,
    required this.developers,
  });

  factory FavoriteResponseData.fromJson(Map<String, dynamic> json) {
    return FavoriteResponseData(
      properties:
          (json['saved_properties'] as List?)
              ?.map((e) => FavoriteProperty.fromJson(e))
              .toList() ??
          [],

      agents:
          (json['saved_agents'] as List?)
              ?.map((e) => AgentModel.fromJson(e))
              .toList() ??
          [],

      developers: [],
    );
  }
}
