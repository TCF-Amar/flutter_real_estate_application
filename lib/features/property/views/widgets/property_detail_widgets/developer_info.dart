import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/developer_card.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class DeveloperInfo extends StatelessWidget {
  const DeveloperInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          HeaderText(text: "Developer Info"),
          SizedBox(height: 16),
          //? developer info goes here
          DeveloperCard(
            logo:
                "https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_1280.png",
            name: "Developer Name",
            projectCount: 10,
            experience: "10+ Years",
          ),
        ],
      ),
    );
  }
}
