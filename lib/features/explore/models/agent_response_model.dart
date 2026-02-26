import 'package:real_estate_app/features/explore/models/agent_model.dart';
import 'package:real_estate_app/features/shared/models/pagination_model.dart';


class AgentResponseMode {
  final bool status;
  final AgentData data;

  AgentResponseMode({required this.status, required this.data});

  factory AgentResponseMode.fromJson(Map<String, dynamic> json) {
    return AgentResponseMode(
      status: json['status'] as bool,
      data: AgentData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson()};
  }
}

class AgentData {
  final List<AgentModel> agents;
  final PaginationModel pagination;

  AgentData({required this.agents, required this.pagination});

  factory AgentData.fromJson(Map<String, dynamic> json) {
    return AgentData(
      agents: (json['agents'] as List<dynamic>)
          .map((e) => AgentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agents': agents.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
