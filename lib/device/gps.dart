import 'package:f_gps_tracker/ui/pages/permission/permission_page.dart';
import 'package:geolocator/geolocator.dart';


class GpsSensor {
  Future<LocationPermission> get permissionStatus async =>
      Geolocator.checkPermission();

  // Usando GeoLocator verifica el estado de los permisos

  Future<Position> get currentLocation async =>

  Geolocator.getCurrentPosition();

      // Usando GeoLocator obten la posicion actual

  Future<LocationAccuracyStatus> get locationAccuracy async {
    try {
      return await Geolocator.getLocationAccuracy();
    }
    catch (error) {
      return LocationAccuracyStatus.unknown;
    }
  }
      // Usando GeoLocator verifica la precision de la ubicacion con soporte para web

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();

  }
}
