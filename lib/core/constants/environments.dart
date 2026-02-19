import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  static final String baseUrl = dotenv.env['BASE_URL']!;
}
