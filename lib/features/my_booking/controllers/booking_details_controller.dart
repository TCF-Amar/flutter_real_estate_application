import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/services/booking_services.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';

class BookingDetailsController extends GetxController {
  final BookingServices bookingServices = Get.find();
  final log = Logger();
  final bookingId = Get.arguments;
  @override
  void onInit() {
    super.onInit();
    getBookingDetails();
  }

  final bookingDetails = Rxn<BookingDetailsData>();
  final bookingDetailsLoading = false.obs;
  final failure = Rxn<Failure>();

  Future<void> getBookingDetails() async {
    bookingDetailsLoading.value = true;
    failure.value = null;
    final result = await bookingServices.getBookingDetails(bookingId.toInt());
    result.fold(
      (error) {
        failure.value = error;
        bookingDetailsLoading.value = false;
      },
      (response) {
        bookingDetails.value = response.data;
        bookingDetailsLoading.value = false;
      },
    );
  }

  final selectedImageIndex = 0.obs;
  int get currentImageIndex => selectedImageIndex.value;

  void onImageTap(int index) {
    selectedImageIndex.value = index;
  }
}
