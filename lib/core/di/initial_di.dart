import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/networks/dio_client.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/services/auth_services.dart';
import 'package:real_estate_app/core/storage/token_storage.dart';

class InitialDi {
  static void init() {
    Get.put(FlutterSecureStorage());
    Get.put(TokenStorage(Get.find<FlutterSecureStorage>()));
    Get.put(DioClient());
    Get.put(DioHelper(Get.find<DioClient>()));
    Get.put(AuthServices());
  }
}
