import 'package:f_gps_tracker/ui/controllers/gps.dart';
import 'package:f_gps_tracker/ui/controllers/location.dart';
import 'package:f_gps_tracker/ui/pages/content/content_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _LocationState();
}

class _LocationState extends State<PermissionPage> {
  late GpsController controller;
  late Future<LocationPermission> _permissionStatus;

  @override
  void initState() {
    super.initState();
    controller = Get.find();

    _permissionStatus= controller.permissionStatus;
    // TODO: Asigna a _permissionStatus el futuro que obtiene el estado de los permisos.;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS Tracker"),
      ),
      body: FutureBuilder<LocationPermission>(
        future: _permissionStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final status = snapshot.data!;
            if (status == LocationPermission.always ||
                status == LocationPermission.whileInUse) {
              final LocationController lc1 = Get.find<LocationController>();
                  lc1.initialize().then(
                    (value) => WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Get.offAll(() => ContentPage()),
                    ),
                  );

              return const Center(
                child: CircularProgressIndicator(),
              );

            } else if (status == LocationPermission.unableToDetermine ||
                status == LocationPermission.denied) {
              return Center(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _permissionStatus = controller.requestPermission();
                        });
                    },
                    child: const Text("Solicitar Permisos")),
              );
            } else {

              return const Text("Permiso denegado, vuelva a cambiar su configuracion");
            }
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError) {

            return const Text("Error de conexion, intente mas tarde");
          } else {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
