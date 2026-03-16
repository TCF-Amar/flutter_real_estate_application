import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';
import 'package:real_estate_app/features/property/models/property_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class BookSiteVisit extends StatefulWidget {
  final PropertyDetail propertyDetail;
  final Function(VisitConfirmationModel)? onNext;
  const BookSiteVisit({super.key, required this.propertyDetail, this.onNext});

  @override
  State<BookSiteVisit> createState() => _BookSiteVisitState();
}

class _BookSiteVisitState extends State<BookSiteVisit> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _visitWith = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                onSurface: AppColors.textPrimary,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: child!,
              ),
            ),
          ),
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isStartTime ? _startTime : _endTime) ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                onSurface: AppColors.textPrimary,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                // constrainedAxis: Axis.horizontal,
                constraints: BoxConstraints(maxWidth: Get.width),
                child: child!,
              ),
            ),
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          _startTimeController.text = picked.format(context);
        } else {
          _endTime = picked;
          _endTimeController.text = picked.format(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.propertyDetail;
    return Scaffold(
      appBar: const DefaultAppBar(title: 'Book a Site Visit'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContainer(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Choose your preferred date & time to visit ${p.title}",
                    overflow: TextOverflow.clip,
                  ),

                  const SizedBox(height: 18),

                  const AppText(
                    "Full Name",
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                  AppTextFormField(
                    controller: _nameController,
                    hintText: "Enter Your full name",
                    keyboardType: TextInputType.name,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  const AppText(
                    "Email",
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                  AppTextFormField(
                    controller: _emailController,
                    hintText: "Enter your email address",
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  const AppText(
                    "Phone",
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                  AppTextFormField(
                    controller: _phoneController,
                    hintText: "Enter your phone number",
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Please enter your phone number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  const AppText(
                    "Preferred Date",
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                  AppTextFormField(
                    controller: _dateController,
                    hintText: "Select Date",
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Please select a date";
                      }
                      return null;
                    },
                    onTap: () => _selectDate(context),
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const AppText(
                    "Time Slot",
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          controller: _startTimeController,
                          hintText: "Select Time",
                          labelText: "Time",
                          readOnly: true,
                          keyboardType: TextInputType.datetime,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Please select visit time";
                            }
                            return null;
                          },
                          onTap: () => _selectTime(context, true),
                          suffixIcon: const Icon(
                            Icons.access_time_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const AppText("— To —"),
                      const SizedBox(width: 6),

                      Expanded(
                        child: AppTextFormField(
                          controller: _endTimeController,
                          hintText: "Select Time",
                          labelText: "Time",
                          readOnly: true,
                          keyboardType: TextInputType.datetime,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Please select visit time";
                            }
                            return null;
                          },
                          onTap: () => _selectTime(context, false),
                          suffixIcon: const Icon(
                            Icons.access_time_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const AppText(
                    "Visit With",
                    fontSize: 14,
                    color: AppColors.textTertiary,
                  ),

                  SizedBox(
                    height: 50,
                    child: DropdownFlutter(
                      items: const ["Self", "Family"],
                      decoration: CustomDropdownDecoration(
                        closedBorder: Border.all(color: AppColors.grey),
                      ),

                      onChanged: (value) {
                        setState(() {
                          _visitWith = value ?? "Self";
                        });
                      },

                      validator: (v) {
                        if (v!.isEmpty) {
                          return "This field are required";
                        }
                        return null;
                      },
                      hintBuilder: (context, hint, enabled) {
                        return const AppText("Select");
                      },
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      AppText(
                        "Message",
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                      AppText(
                        " (Optional)",
                        fontSize: 10,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                  AppTextFormField(
                    controller: _messageController,
                    hintText: "Enter your message",
                    keyboardType: TextInputType.multiline,

                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: AppButton(
            text: "Book Site Visit",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final model = VisitConfirmationModel(
                  property: widget.propertyDetail,
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  date: _dateController.text,
                  apiDate: DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  startTime: _startTimeController.text,
                  apiStartTime:
                      "${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00",
                  endTime: _endTimeController.text,
                  apiEndTime:
                      "${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00",
                  message: _messageController.text,
                  visitWith: _visitWith,
                );

                if (widget.onNext != null) {
                  widget.onNext!(model);
                } else {
                  Get.toNamed(
                    AppRoutes.visitConfirmationPrev,
                    arguments: model,
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
