import 'package:flutter/material.dart';
import 'package:real_estate_app/features/my_booking/models/visit_detail_response.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/visit_details_app_bar.dart';
import 'package:real_estate_app/features/my_booking/views/widgets/visit_details/visit_details_thumbnails.dart';

class VisitDetailsGallery extends StatefulWidget {
  final VisitData data;
  const VisitDetailsGallery({super.key, required this.data});

  @override
  State<VisitDetailsGallery> createState() => _VisitDetailsGalleryState();
}

class _VisitDetailsGalleryState extends State<VisitDetailsGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.data.property?.images ?? [];
    return SliverMainAxisGroup(
      slivers: [
        VisitDetailsAppBar(
          imageUrl: images.isNotEmpty ? images[_selectedIndex].url ?? '' : '',
        ),
        VisitDetailsThumbnails(
          images: images,
          selectedIndex: _selectedIndex,
          onImageSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ],
    );
  }
}
