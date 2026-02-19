import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/core/networks/interceptors/dio_interceptor.dart';
import 'package:real_estate_app/core/storage/token_storage.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = _createDio();
  }

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Environments.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );
    dio.interceptors.add(DioInterceptors(Get.find<TokenStorage>(), dio));

    return dio;
  }
}
