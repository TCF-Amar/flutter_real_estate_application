import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/developer_card.dart';

class DevelopersView extends StatelessWidget {
  const DevelopersView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final developers = List.generate(
      5,
      (index) => {
        "logo": "https://logodix.com/logo/1828873.png", // Example logo
        "name": "Lodha Group ${index + 1}",
        "projectCount": 15 + index,
        "experience": "${8 + index}+ Years",
      },
    );

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: developers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final dev = developers[index];
        return DeveloperCard(
          logo: dev["logo"] as String,
          name: dev["name"] as String,
          projectCount: dev["projectCount"] as int,
          experience: dev["experience"] as String,
          onTapToggle: () {},
          onViewDetails: () {},
        );
      },
    );
  }
}
