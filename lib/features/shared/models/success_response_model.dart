class SuccessResponseModel<T> {
  final bool status;
  final T data;

  SuccessResponseModel({required this.status, required this.data});

  factory SuccessResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return SuccessResponseModel(
      status: json['status'] is bool ? json['status'] : true,
      data: fromJsonT(json['data']),
    );
  }


  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {'status': status, 'data': toJsonT(data)};
  }
}
