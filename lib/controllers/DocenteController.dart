import 'dart:convert';
import 'package:aula_idiomas_app/controllers/ListaDocenteController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DocenteController extends GetxController {
  var isLoadingGuardar = false.obs;
  final listaDocentecontroller = Get.find<ListaDocenteController>();
  
  Future<void> guardarDocente(
    String nombres,
    String apPaterno,
    String apMaterno,
    String email,
  ) async {
    if (nombres.isEmpty || apPaterno.isEmpty || email.isEmpty) {
      Get.snackbar(
        'Campos requeridos',
        'Por favor completa nombre, apellido paterno y correo electrónico.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingGuardar.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      var url = Uri.parse(
        'http://127.0.0.1:8000/api/coordinacion/guardar-docente',
      );
      var response = await http.post(
        url,
        body: jsonEncode({
          "email": email,
          "nombres": nombres,
          "ap_paterno": apPaterno,
          "ap_materno": apMaterno,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar(
          'Éxito',
          'Docente guardado exitosamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.teal,
          colorText: Colors.white,
        );

        Navigator.pop(Get.context!, true);
      } else {
        Get.snackbar(
          'Error al guardar',
          data['message'] ?? 'Ocurrió un error inesperado',
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
      isLoadingGuardar.value = false;
    }
  }

  Future<void> deshabilitarDocente(int idDocente) async {
    var isLoading = false.obs;
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/coordinacion/docente/eliminar/$idDocente'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar(
          'Éxito',
          'Docente deshabilitado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        listaDocentecontroller.refreshDocentes();
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Ocurrió un error',
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

  Future<void> habilitarDocente(int idDocente) async {
    var isLoading = false.obs;
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/coordinacion/docente/restaurar/$idDocente'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar(
          'Éxito',
          'Docente habilitado correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        listaDocentecontroller.refreshDocentes();
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Ocurrió un error',
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

