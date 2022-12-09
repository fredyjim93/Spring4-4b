import 'package:f_gps_tracker/domain/models/location.dart';
import 'package:f_gps_tracker/domain/use_cases/location_manager.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final Rx<List<TrackedLocation>> _locations = Rx([]);

  List<TrackedLocation> get locations => _locations.value;

  Future<void> initialize() async {
    await LocationManager.initialize();
  }

  Future<void> saveLocation({
    required TrackedLocation location,
  }) async {
    await LocationManager.save(location: location);
    _locations.update((records) {
      records!.add(location);
    });
    /* TODO: Usa [LocationManager] para guardar [save] la ubicacion [location] */
  }

 Future<List<TrackedLocation>> getAll({
    String? orderBy,
  }) async {
   _locations.value = await LocationManager.getAll();
    return _locations.value;

    /* TODO: Usa [getAll] de [LocationManager] para obtener la lista de ubicaciones guardadas y retornalas */
  }

  Future<void> updateLocation({required TrackedLocation location}) async {
    await LocationManager.update(location: location);
    _locations.value = await LocationManager.getAll();


  }

  Future<void> deleteLocation({required TrackedLocation location}) async {

    await LocationManager.delete(location: location);
    _locations.update((records) {
      records!.removeWhere((record) => record.uuid == location.uuid);
    });

  }

  Future<void> deleteAll() async {
    await LocationManager.deleteAll();
    _locations.value= [];


  }
}
