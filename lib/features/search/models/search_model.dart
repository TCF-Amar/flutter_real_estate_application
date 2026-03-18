class RecentSearchModel {
  final String query;
  final String image;
  final String title;
  final String location;

  RecentSearchModel({
    required this.query,
    required this.image,
    required this.title,
    required this.location,
  });

  factory RecentSearchModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchModel(
      query: json['query'],
      image: json['image'],
      title: json['title'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'image': image,
      'title': title,
      'location': location,
    };
  }
}

List<RecentSearchModel> recentSearches = [
  RecentSearchModel(
    query: "Apartment",
    image: "",
    title: "Luxury Villa in Dubai Marina",
    location: "Dubai Marina, Dubai",
  ),
  RecentSearchModel(
    query: "",
    image: "",
    title: "Luxury Villa in Dubai Marina",
    location: "Dubai Marina, Dubai",
  ),
  RecentSearchModel(
    query: "",
    image: "",
    title: "Luxury Villa in Dubai Marina",
    location: "Dubai Marina, Dubai",
  ),
  RecentSearchModel(
    query: "",
    image: "",
    title: "Luxury Villa in Dubai Marina",
    location: "Dubai Marina, Dubai",
  ),
  RecentSearchModel(
    query: "",
    image: "",
    title: "Luxury Villa in Dubai Marina",
    location: "Dubai Marina, Dubai",
  ),
];
