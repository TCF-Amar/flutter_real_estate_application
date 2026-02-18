import 'package:real_estate_app/core/constants/app_assets.dart';

/// Model class representing data for a single onboarding page
class OnboardingPageData {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPageData(
    this.image, {
    required this.title,
    required this.subtitle,
  });

  /// Static list of onboarding pages
  static List<OnboardingPageData> get pages => [
    OnboardingPageData(
      Assets.images.getStart2,
      title: "Find Your Dream Home On The Go",
      subtitle: "Discover properties effortlessly, right from your phone.",
    ),
    OnboardingPageData(
      Assets.images.getStart1,
      title: "Buy or Rent, Your Choice",
      subtitle: "Get the best deals and verified listings in your area.",
    ),
    OnboardingPageData(
      Assets.images.getStart3,
      title: "Start Your Journey Today",
      subtitle: "Let's help you move into your perfect place.",
    ),
  ];
}
