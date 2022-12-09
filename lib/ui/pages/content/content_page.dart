import 'package:f_gps_tracker/domain/models/location.dart';
import 'package:f_gps_tracker/ui/controllers/gps.dart';
import 'package:f_gps_tracker/ui/controllers/location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentPage extends GetView<LocationController> {
  late final GpsController gpsController = Get.find();

  ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS Tracker"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final cl1 = await gpsController.currentLocation;
                        final al1 = await gpsController.locationAccuracy;
                        TrackedLocation tl1 = TrackedLocation (precision: al1.name, timestamp: DateTime.now(), latitude: cl1.latitude, longitude: cl1.longitude);
                        controller.saveLocation(location: tl1);

                      },
                      child: const Text("Registrar Ubicacion"),
                      style: ButtonStyle(shadowColor: MaterialStatePropertyAll(Colors.cyan)),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView.separated(
                        padding: const EdgeInsets.all(8.0),
            itemCount: controller.locations.length,
                        itemBuilder: (context, index) {
                          final location = controller.locations[index];
                          return Card(
                            child: ListTile(
                              isThreeLine: true,
                              leading: Icon(
                                Icons.gps_fixed_rounded,
                                color: Colors.grey,
                                shadows: [Shadow(color: Colors.greenAccent,blurRadius: 1 )],
                              ),
                              title: Text(
                                  '${location.latitude}, ${location.longitude}'),
                              subtitle: Text(
                                  'Fecha: ${location.timestamp.toIso8601String()}\n${location.precision.toUpperCase()}'),
                              trailing: IconButton(
                                onPressed: () {
                                  controller.deleteLocation(location: location);

                                },
                                icon: const Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red,
                                  shadows: [Shadow(color: Colors.deepOrange,blurRadius: 1 )],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        controller.deleteAll();

                      },
                      child: const Text("Eliminar Todos"),
                      style: ButtonStyle(shadowColor: MaterialStatePropertyAll(Colors.redAccent),backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
