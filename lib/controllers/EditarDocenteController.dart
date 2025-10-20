import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditarDocenteController extends GetxController {
  var isLoading = false.obs;
  var docenteData = {}.obs;

  Future<void> fetchDocente(int idDocente) async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/coordinacion/docente/$idDocente'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          docenteData.value = data['data'];
        } else {
          Get.snackbar(
            'Error',
            data['message'] ?? 'No se pudo obtener la información',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Error al obtener docente: ${response.body}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error de red',
        'No se pudo conectar con el servidor: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> actualizarDocente(
      int idDocente,
      String nombres,
      String apPaterno,
      String apMaterno,
      String email,
      context) async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final response = await http.put(
        Uri.parse(
            'http://127.0.0.1:8000/api/coordinacion/docente-editar/$idDocente'), // Cambia según tu emulador/dispositivo
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "nombres": nombres,
          "ap_paterno": apPaterno,
          "ap_materno": apMaterno,
          "email": email,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Datos actualizados correctamente.'),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pop(Get.context!, true);

      } else {
        
        String mensajeError = data['message'] ?? 'Ocurrió un error inesperado';

        if (response.statusCode == 422 && data['errors'] != null) {
          final errores = (data['errors'] as Map)
              .values
              .expand((e) => e)
              .join('\n'); 
          mensajeError = errores;
        }

        Get.snackbar(
          'Error',
          mensajeError,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error de red',
        'No se pudo conectar con el servidor: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

}
