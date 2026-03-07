import 'package:geolocator/geolocator.dart';

class LocationPermissionUtil {

  static Future<bool> hasPermission() async {

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<bool> requestPermission() async {

    LocationPermission permission =
        await Geolocator.requestPermission();

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

}