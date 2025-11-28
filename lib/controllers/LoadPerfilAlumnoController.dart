import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoadPerfilAlumnoController extends GetxController {
  var isLoadingPerfil = false.obs;
  var hasError = false.obs;
  var userData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadPerfilAlumno();
  }

  Future<void> loadPerfilAlumno() async {
    try {
      isLoadingPerfil.value = true;
      hasError.value = false;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');
      final userId = prefs.getInt('userId');

      if (token == null || userId == null) {
        Get.snackbar(
          'Error',
          'No se encontró sesión activa.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        hasError.value = true;
        return;
      }

      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_CARGAR_PERFIL_ALUMNO']}/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final usuario = data['usuario'];
        final nombreCompleto =
            '${usuario['nombres']} ${usuario['ap_paterno']}';

        userData.value = {
          'nombre': nombreCompleto,
          'matricula': usuario['matricula'] ?? 'Sin matrícula',
          'carrera': data['carrera'] ?? 'Sin carrera',
          'promedio': data['promedio']?.toString() ?? 'N/A',
        };
      } else {
        hasError.value = true;
        Get.snackbar(
          'Error',
          'No se pudo obtener la información del perfil.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar(
        'Error',
        'Ocurrió un error al cargar el perfil.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('Error al cargar perfil: $e');
    } finally {
      isLoadingPerfil.value = false;
    }
  }
}
