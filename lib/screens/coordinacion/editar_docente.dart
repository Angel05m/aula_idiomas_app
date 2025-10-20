import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
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
  // Variables para la seleccion en galeria y web
  //Variable para android
  File? _imagen;
  //Variable para web
  Uint8List? _imagenWeb;
  final ImagePicker _pick = ImagePicker();

  Future<void> _pickImagen(imageSource) async {
    final XFile? pickedFiel = await _pick.pickImage(source: imageSource);
    // Funciones para seleccion de web o movil
    if (pickedFiel != null) {
      if (kIsWeb) {
        final bytesWeb = await pickedFiel.readAsBytes();
        setState(() {
          _imagenWeb = bytesWeb;
        });
      } else {
        setState(() {
          _imagen = File(pickedFiel.path);
        });
      }
    }
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
                    context
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

  // Apartado para mostrar la imagen seleccionada
  Widget imagenUsuario() {
    return _imagen != null
        ? ClipOval(
            child: Image.file(
              _imagen!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          )
        : _imagenWeb != null
        ? ClipOval(
            child: Image.memory(
              _imagenWeb!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          )
        : const Icon(Icons.person, size: 40, color: Colors.white);
  }
}
