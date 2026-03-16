import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/my_booking/controllers/my_booking_controller.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/booking_recap_item.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitConfirmationPrev extends StatelessWidget {
  final VisitConfirmationModel visitConfirmationModel;
  final VoidCallback? onBack;
  final Function(VisitConfirmationModel)? onNext;
  const VisitConfirmationPrev({
    super.key,
    required this.visitConfirmationModel,
    this.onBack,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final MyBookingController controller = Get.find();
    final m = visitConfirmationModel;
    final property = m.property;
    return Scaffold(
      body: AppContainer(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            SizedBox(height: Get.size.height),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: Get.size.height * 0.6,
              child: AppImage(
                path: visitConfirmationModel.property.media?.images[0].url,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.grey.withValues(alpha: 0.5),
                    child: IconButton(
                      onPressed: () {
                        if (onBack != null) {
                          onBack!();
                        } else {
                          Get.back();
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  HeaderText(
                    text: "Confirmation Preview",
                    color: AppColors.white,
                    shadow: true,
                    shadowColor: AppColors.black,
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Positioned(
              top: Get.size.height * 0.2,
              bottom: 100,
              left: 0,
              right: 0,
              child: AppContainer(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                showShadow: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: property.title!,
                        color: AppColors.textSecondary,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSvg(path: Assets.icons.location, height: 15),
                          const SizedBox(width: 6),
                          Expanded(
                            child: AppText(
                              property.address!.toString(),
                              fontSize: 14,
                              overflow: TextOverflow.clip,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppContainer(
                        color: AppColors.grey.withValues(alpha: 0.1),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 0),
                        child: Column(
                          children: [
                            BookingRecapItem(
                              path: Assets.icons.personSelected,
                              subtitle: "Visitor Name",
                              title: m.name,
                            ),
                            BookingRecapItem(
                              path: Assets.icons.phone,
                              subtitle: "Phone Number",
                              title: m.phone,
                            ),
                            BookingRecapItem(
                              path: Assets.icons.mail,
                              subtitle: "Email Address",
                              title: m.email,
                            ),
                            BookingRecapItem(
                              icon: Icons.calendar_today,
                              subtitle: "Preferred Date",
                              title: m.date,
                            ),
                            BookingRecapItem(
                              icon: Icons.watch_later,
                              subtitle: "Time Slot",
                              title: "${m.startTime} - to - ${m.endTime}",
                            ),
                            BookingRecapItem(
                              icon: Icons.person_add_alt_1,
                              subtitle: "Visiting With",
                              title: m.visitWith,
                            ),
                            m.message.trim().isNotEmpty
                                ? BookingRecapItem(
                                    icon: Icons.message,
                                    subtitle: "Message",
                                    title: m.message,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppButton(
                      text: "Cancel",
                      isBorder: true,
                      backgroundColor: Colors.transparent,
                      showShadow: false,
                      borderColor: AppColors.grey,
                      textColor: AppColors.grey,
                      fontSize: 14,
                      onPressed: () {
                        if (onBack != null) {
                          onBack!();
                        } else {
                          Get.back();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => AppButton(
                        text: "Confirm booking",
                        fontSize: 14,
                        isLoading: controller.visitBooking.value,
                        onPressed: () async {
                          final requestModel = VisitConfirmRequestModel(
                            name: m.name,
                            email: m.email,
                            phone: m.phone,
                            message: m.message,
                            propertyId: m.property.id,
                            countryCode: "us",
                            preferredDate: m.apiDate,
                            timeSlotFrom: m.apiStartTime,
                            timeSlotTo: m.apiEndTime,
                            visitingWith: m.visitWith,
                          );

                          final result = controller.visitBook(requestModel);
                          if (await result) {
                            if (onNext != null) {
                              onNext!(m);
                            } else {
                              Get.offAllNamed(
                                AppRoutes.visitBookingConfirm,
                                arguments: m,
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
