import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/core/utils/safe_parser.dart';

class ProjectOverviewModel {
  final String? percentageComplete;
  final int? progressValue;
  final String? status;
  final String? possessionDate;
  final List<ProjectStage>? stages;

  const ProjectOverviewModel({
    this.percentageComplete,
    this.progressValue,
    this.status,
    this.possessionDate,
    this.stages,
  });

  factory ProjectOverviewModel.fromJson(Map<String, dynamic> json) {
    return ProjectOverviewModel(
      percentageComplete: toStr(json['percentage_complete']),
      progressValue: toInt(json['progress_value']),
      status: toStr(json['status']),
      possessionDate: toStr(json['possession_date']),
      stages: (json['stages'] as List<dynamic>?)
          ?.map((e) => ProjectStage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'percentage_complete': percentageComplete,
    'progress_value': progressValue,
    'status': status,
    'possession_date': possessionDate,
    'stages': stages?.map((e) => e.toJson()).toList(),
  };
}

class ProjectStage {
  final String? name;
  final String? status;
  final int? percentage;

  const ProjectStage({this.name, this.status, this.percentage});

  factory ProjectStage.fromJson(Map<String, dynamic> json) {
    return ProjectStage(
      name: toStr(json['name']),
      status: toStr(json['status']),
      percentage: toInt(json['percentage']),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'status': status,
    'percentage': percentage,
  };
}

class LatestUpdateModel {
  final int? id;
  final String? date;
  final String? title;
  final String? description;
  final List<String>? images;

  const LatestUpdateModel({
    this.id,
    this.date,
    this.title,
    this.description,
    this.images,
  });

  factory LatestUpdateModel.fromJson(Map<String, dynamic> json) {
    return LatestUpdateModel(
      id: toInt(json['id']),
      date: toStr(json['date']),
      title: toStr(json['title']),
      description: toStr(json['description']),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => "${Environments.baseUrl}${toStr(e)}")
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'title': title,
    'description': description,
    'images': images,
  };
}
