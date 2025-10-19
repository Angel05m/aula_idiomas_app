import 'package:aula_idiomas_app/controllers/EditarDocenteController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditarDocente extends StatefulWidget {
  final int idDocente;
  const EditarDocente({super.key, required this.idDocente});

  @override
  State<EditarDocente> createState() => _EditarDocenteState();
}

class _EditarDocenteState extends State<EditarDocente> {
  final controller = Get.put(EditarDocenteController());

  final nombresController = TextEditingController();
  final apPaternoController = TextEditingController();
  final apMaternoController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchDocente(widget.idDocente).then((_) {
      final data = controller.docenteData;
      nombresController.text = data['nombres'] ?? '';
      apPaternoController.text = data['ap_paterno'] ?? '';
      apMaternoController.text = data['ap_materno'] ?? '';
      emailController.text = data['email'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Docente',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nombres', nombresController),
              _buildTextField('Apellido Paterno', apPaternoController),
              _buildTextField('Apellido Materno', apMaternoController),
              _buildTextField('Correo', emailController),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  controller.actualizarDocente(
                    widget.idDocente,
                    nombresController.text.trim(),
                    apPaternoController.text.trim(),
                    apMaternoController.text.trim(),
                    emailController.text.trim(),
                  );
                },
                child: const Text(
                  'Actualizar Información',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.teal, width: 3.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
