import 'package:location/location.dart';

class LocationService {
  Location _location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  askService() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }
  }

  askPermission() async {
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }
  }

  Future<LocationData> getActualLocation() async {
    
    askPermission();
    askService();
    
    bool granted = (_permissionGranted == PermissionStatus.granted) && (_serviceEnabled);

    if(!granted) return null;

    _locationData = await _location.getLocation();

    return _locationData;
  }
}