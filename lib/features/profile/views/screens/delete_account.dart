import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/features/profile/controllers/profile_controller.dart';
import 'package:real_estate_app/features/profile/views/widgets/account_delete_widget/delete.dart';
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
    final ProfileController controller = Get.find();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppBackButton(),
        ),
        title: HeaderText(text: "Delete Account"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFormField(
                  hintText: "password",
                  controller: _passwordController,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                  // keyboardType: TextInputType.,
                ),

                const SizedBox(height: 20),

                AppTextFormField(
                  hintText: "confirm password",
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter your confirm password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextFormField(
                  hintText: "Type \"DELETE\"",
                  controller: _confirmationController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter your confirmation";
                    }
                    if (v != "DELETE") {
                      return "Please type \"DELETE\" correctly";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: "Delete Account",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final password = _passwordController.text.trim();
                      final confirmation = _confirmationController.text.trim();

                      accountDeleteConfirmation(context, () {
                        controller.handleDeleteAccount(
                          password: password,
                          confirmation: confirmation,
                        );
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
