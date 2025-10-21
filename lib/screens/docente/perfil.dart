
import 'package:aula_idiomas_app/controllers/LoadPerfilController.dart';
import 'package:aula_idiomas_app/screens/coordinacion/editar_perfil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerfilDocente extends StatelessWidget {
  const PerfilDocente({super.key});

  @override
  Widget build(BuildContext context) {
    final loadPerfilController = Get.put(LoadPerfilController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil Docente',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (loadPerfilController.isLoadingPerfil.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (loadPerfilController.hasError.value) {
          return const Center(
            child: Text(
              'Error al cargar el perfil.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        final user = loadPerfilController.userData.value;
        if (user == null) {
          return const Center(child: Text('No hay datos del usuario.'));
        }

        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 50,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: 120,
                height: 50,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditarPerfilCordinador(),
                    ),
                  ),
                  child: const Text(
                    'Editar perfil',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Información General',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              infoRow(
                'Nombre:',
                '${user['nombres'] ?? ''} ${user['ap_paterno'] ?? ''} ${user['ap_materno'] ?? ''}'
                    .trim(),
              ),
              const Divider(),
              infoRow('Correo:', user['email'] ?? 'Sin correo'),
              const Divider(),
            ],
          ),
        );
      }),
    );
  }

  Widget infoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            label,
            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
