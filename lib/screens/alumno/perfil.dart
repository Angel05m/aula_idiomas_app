import 'package:aula_idiomas_app/controllers/LoadPerfilAlumnoController.dart';
import 'package:aula_idiomas_app/screens/alumno/editar_perfil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilAlumno extends StatelessWidget {
  const PerfilAlumno({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoadPerfilAlumnoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil Alumno',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoadingPerfil.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value || controller.userData.value == null) {
          return Center(
            child: Text(
              'No se pudo cargar la información del perfil.',
              style: TextStyle(fontSize: 16, color: Colors.red[700]),
            ),
          );
        }

        final user = controller.userData.value!;
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 50,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: 120,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const EditarPerfilAlumno());
                      },
                      child: const Text(
                        'Editar perfil',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'Información General',
                      style:
                          TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    infoRow('Nombre:', user['nombre']),
                    infoRow('Matrícula:', user['matricula']),
                    infoRow('Carrera:', user['carrera']),
                    infoRow('Promedio:', user['promedio']),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget infoRow(String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                label,
                style:
                    const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
