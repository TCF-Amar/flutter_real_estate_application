import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/profile/views/widgets/support_widgets/req_suc_dialog.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class NewRequest extends StatelessWidget {
  const NewRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final dropItem = ["Property", "Payment", "Booking", "Document"];
    return Scaffold(
      appBar: DefaultAppBar(title: "New Request"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText("Describe the problem you’re facing ", fontSize: 16),
              const SizedBox(height: 10),
              AppText("Subject/issue", fontSize: 14),
              const SizedBox(height: 10),
              DropdownFlutter(
                items: [...dropItem],
                onChanged: (value) {},
                decoration: CustomDropdownDecoration(
                  closedBorder: Border.all(color: AppColors.grey, width: 1),
                ),
              ),
              const SizedBox(height: 10),
              AppText("Description", fontSize: 14),
              const SizedBox(height: 10),
              AppTextFormField(
                maxLines: 5,
                borderColor: AppColors.grey,
                hintText: "Please describe your issue in detail",
              ),
              Spacer(),
              AppButton(
                text: "Submit Request",
                onPressed: () => showRequestSuccess(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
