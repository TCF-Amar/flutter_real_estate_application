import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/utils/location_permission_util.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class LocationAccessTile extends StatefulWidget {
  const LocationAccessTile({super.key});

  @override
  State<LocationAccessTile> createState() => _LocationAccessTileState();
}

class _LocationAccessTileState extends State<LocationAccessTile> {
  bool _hasPermission = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await LocationPermissionUtil.hasPermission();
    if (mounted) {
      setState(() {
        _hasPermission = status;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleToggle(bool newValue) async {
    if (newValue) {
      final granted = await LocationPermissionUtil.requestPermission();
      if (mounted) {
        setState(() {
          _hasPermission = granted;
        });
      }
      if (!granted) {
        // If denied forever, open settings
        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.deniedForever) {
          await Geolocator.openAppSettings();
        }
      }
    } else {
      // Cannot revoke permission programmatically, must open settings
      await Geolocator.openAppSettings();

      setState(() {
        _hasPermission = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "Location Access",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                AppText(
                  "Allow location access to see nearby properties and improve your search experience.",
                  fontSize: 10,
                  color: AppColors.textTertiary,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (_isLoading)
            const SizedBox(
              width: 60,
              height: 32,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else
            CustomToggleSwitch(
              initialValue: _hasPermission,
              onChanged: _handleToggle,
            ),
        ],
      ),
    );
  }
}
