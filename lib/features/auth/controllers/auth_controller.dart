import 'package:get/get.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';

class AuthController extends GetxController {
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAndToNamed(AppRoutes.getStart);
    });
  }

  void handleSignIn() {}

  void handleSignUp() {}

  void handleForgotPassword() {}
}
