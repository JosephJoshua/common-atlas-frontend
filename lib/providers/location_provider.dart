import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

enum LocationStatus { initial, loading, available, denied, error }

class LocationProvider with ChangeNotifier {
  final Location _location = Location();
  LocationData? _currentLocationData;
  LatLng? _currentLatLng;
  LocationStatus _status = LocationStatus.initial;
  String? _errorMessage;

  LocationData? get currentLocationData => _currentLocationData;
  LatLng? get currentLatLng => _currentLatLng;
  LocationStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> initializeLocation() async {
    _status = LocationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          _status = LocationStatus.denied;
          _errorMessage = 'Location services are disabled.';
          notifyListeners();
          return;
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _status = LocationStatus.denied;
          _errorMessage = 'Location permission was denied.';
          notifyListeners();
          return;
        }
      }

      if (permissionGranted == PermissionStatus.granted ||
          permissionGranted == PermissionStatus.grantedLimited) {
        _currentLocationData = await _location.getLocation();

        if (_currentLocationData != null &&
            _currentLocationData!.latitude != null &&
            _currentLocationData!.longitude != null) {
          _currentLatLng = LatLng(
            _currentLocationData!.latitude!,
            _currentLocationData!.longitude!,
          );

          _status = LocationStatus.available;

          print("Location obtained: $_currentLatLng");
        } else {
          _status = LocationStatus.error;
          _errorMessage = 'Failed to get location data.';
        }
      } else {
        _status = LocationStatus.denied;
        _errorMessage = 'Location permission not granted.';
      }
    } catch (e) {
      print("Error initializing location: $e");
      _status = LocationStatus.error;
      _errorMessage = 'An error occurred: ${e.toString()}';
    } finally {
      notifyListeners();
    }

    _location.onLocationChanged.listen((LocationData newLocationData) {
      if (newLocationData.latitude != null && newLocationData.longitude != null) {
        _currentLocationData = newLocationData;
        _currentLatLng = LatLng(newLocationData.latitude!, newLocationData.longitude!);
        _status = LocationStatus.available; // Ensure status reflects availability
        notifyListeners();
      }
    });
  }
}
