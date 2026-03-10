import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/auth/controllers/auth_controller.dart';
import 'package:real_estate_app/features/profile/views/widgets/accoun_delete_widget/delete.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _confirmationController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _confirmationController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppBackButton(),
        ),
        title: HeaderText(text: "Delete Account"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText("Password", fontSize: 14),
            const SizedBox(height: 4),
            AppTextFormField(
              hintText: "password",
              controller: _passwordController,
              isPassword: true,
              // keyboardType: TextInputType.,
            ),

            const SizedBox(height: 20),
            AppText("Confirm Password", fontSize: 14),
            const SizedBox(height: 4),

            AppTextFormField(
              hintText: "confirm password",
              controller: _confirmPasswordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            AppText("Type \"DELETE\"", fontSize: 14),
            const SizedBox(height: 4),
            AppTextFormField(
              hintText: "Type \"DELETE\"",
              controller: _confirmationController,
            ),
            const SizedBox(height: 20),
            AppButton(
              text: "Delete Account",
              onPressed: () {
                final password = _passwordController.text.trim();
                final confirmPassword = _confirmPasswordController.text.trim();
                final confirmation = _confirmationController.text.trim();

                if (password.isEmpty || confirmPassword.isEmpty) {
                  AppSnackbar.error("Please enter your password");
                  return;
                }

                if (password != confirmPassword) {
                  AppSnackbar.error("Passwords do not match");
                  return;
                }

                if (confirmation != "DELETE") {
                  AppSnackbar.error('Please type "DELETE" correctly');
                  return;
                }

                accountDeleteConfirmation(context, () {
                  authController.handleDeleteAccount(
                    password: password,
                    confirmation: confirmation,
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
