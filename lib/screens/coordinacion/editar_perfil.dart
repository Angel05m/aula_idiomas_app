import 'dart:convert';
import 'package:aula_idiomas_app/controllers/LoadPerfilController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditarPerfilCordinador extends StatefulWidget {
  const EditarPerfilCordinador({super.key});

  @override
  State<EditarPerfilCordinador> createState() => _EditarPerfilCordinadorState();
}

class _EditarPerfilCordinadorState extends State<EditarPerfilCordinador> {
  final loadPerfilController = Get.put(LoadPerfilController());

  final nombresController = TextEditingController();
  final apPaternoController = TextEditingController();
  final apMaternoController = TextEditingController();
  final correoController = TextEditingController();

  var isUpdating = false.obs;

  @override
  void dispose() {
    nombresController.dispose();
    apPaternoController.dispose();
    apMaternoController.dispose();
    correoController.dispose();
    super.dispose();
  }

  Future<void> updatePerfil() async {
    final nombres = nombresController.text.trim();
    final apPaterno = apPaternoController.text.trim();
    final apMaterno = apMaternoController.text.trim();
    final email = correoController.text.trim();

    if (nombres.isEmpty || apPaterno.isEmpty || apMaterno.isEmpty || email.isEmpty) {
      Get.snackbar(
        'Error',
        'Todos los campos son obligatorios',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isUpdating.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final userId = loadPerfilController.userData.value?['pk_usuario'];

      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/perfil-editar/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nombres': nombres,
          'ap_paterno': apPaterno,
          'ap_materno': apMaterno,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Éxito',
          'Perfil actualizado correctamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadPerfilController.loadPerfil();
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          data['message'] ?? 'No se pudo actualizar el perfil',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al actualizar el perfil',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (loadPerfilController.isLoadingPerfil.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.teal));
        }

        if (loadPerfilController.hasError.value) {
          return const Center(child: Text('Ocurrió un error al cargar los datos'));
        }

        final data = loadPerfilController.userData.value;
        if (data != null) {
          if (nombresController.text.isEmpty) nombresController.text = data['nombres'] ?? '';
          if (apPaternoController.text.isEmpty) apPaternoController.text = data['ap_paterno'] ?? '';
          if (apMaternoController.text.isEmpty) apMaternoController.text = data['ap_materno'] ?? '';
          if (correoController.text.isEmpty) correoController.text = data['email'] ?? '';
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nombres', nombresController),
              const SizedBox(height: 10),
              _buildTextField('Apellido Paterno', apPaternoController),
              const SizedBox(height: 10),
              _buildTextField('Apellido Materno', apMaternoController),
              const SizedBox(height: 10),
              _buildTextField('Correo', correoController, isEmail: true),
              const SizedBox(height: 20),
              Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: isUpdating.value ? null : updatePerfil,
                    child: isUpdating.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Actualizar Información', style: TextStyle(color: Colors.white, fontSize: 15)),
                  )),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.teal, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}