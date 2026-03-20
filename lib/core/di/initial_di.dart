import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/networks/dio_client.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/services/agent_services.dart';
import 'package:real_estate_app/core/services/auth_services.dart';
import 'package:real_estate_app/core/services/booking_services.dart';
import 'package:real_estate_app/core/services/home_services.dart';
import 'package:real_estate_app/core/services/maintenance_services.dart';
import 'package:real_estate_app/core/services/profile_services.dart';
import 'package:real_estate_app/core/services/property_services.dart';
import 'package:real_estate_app/core/storage/token_storage.dart';

class InitialDi {
  static void init() {
    Get.lazyPut<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
      fenix: true,
    );

    Get.lazyPut<TokenStorage>(() => TokenStorage(Get.find()), fenix: true);

    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);

    Get.lazyPut<DioHelper>(() => DioHelper(Get.find()), fenix: true);

    Get.lazyPut<AuthServices>(() => AuthServices(), fenix: true);

    Get.lazyPut<ProfileServices>(() => ProfileServices(), fenix: true);

    Get.lazyPut<HomeServices>(() => HomeServices(), fenix: true);

    Get.lazyPut<PropertyServices>(() => PropertyServices(), fenix: true);

    Get.lazyPut<AgentServices>(() => AgentServices(), fenix: true);
   
    Get.lazyPut<MaintenanceServices>(() => MaintenanceServices(), fenix: true);
    Get.lazyPut<BookingServices>(() => BookingServices(), fenix: true);
  }
}
