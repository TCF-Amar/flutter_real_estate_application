import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class VisitDetailsAppBar extends StatelessWidget {
  final String imageUrl;
  const VisitDetailsAppBar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: AppBackButton(),
      ),
      title: const HeaderText(
        text: "Site Visit Detail",
        shadow: true,
        color: Colors.white,
        shadowColor: Colors.black,
      ),
      centerTitle: true,
      collapsedHeight: 70,
      expandedHeight: 300,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppImage(path: imageUrl),
        ),
      ),
    );
  }
}
