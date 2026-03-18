import 'package:get/get.dart';
import 'package:real_estate_app/features/my_booking/controllers/booking_details_controller.dart';

class MyBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingDetailsController());
  }
}
