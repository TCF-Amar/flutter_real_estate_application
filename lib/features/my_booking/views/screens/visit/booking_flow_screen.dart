import 'package:flutter/material.dart';
import 'package:real_estate_app/features/my_booking/models/visit_confirmation_model.dart';
import 'package:real_estate_app/features/my_booking/views/screens/visit/book_site_visit.dart';
import 'package:real_estate_app/features/my_booking/views/screens/visit/visit_confirmation_prev.dart';
import 'package:real_estate_app/features/my_booking/views/screens/visit/visit_booking_confirm.dart';
import 'package:real_estate_app/features/property/models/property_detail_model.dart';

class BookingFlowScreen extends StatefulWidget {
  final PropertyDetail propertyDetail;
  const BookingFlowScreen({super.key, required this.propertyDetail});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  final PageController _pageController = PageController();
  VisitConfirmationModel? _model;

  void _nextPage(VisitConfirmationModel model) {
    setState(() {
      _model = model;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          BookSiteVisit(
            propertyDetail: widget.propertyDetail,
            onNext: _nextPage,
          ),
          if (_model != null) ...[
            VisitConfirmationPrev(
              visitConfirmationModel: _model!,
              onBack: _previousPage,
              onNext: (requestModel) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            VisitBookingConfirm(model: _model!),
          ] else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
