import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlumnosController extends GetxController {
  var isLoading = false.obs;
  var alumnos = <Map<String, dynamic>>[].obs;

  var todasCarreras = <int, String>{}.obs;

  var currentPage = 1;
  var lastPage = 1;

  Future<void> fetchAlumnos({
    String? search,
    String? carrera,
    String? promedio,
    int page = 1,
  }) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final queryParams = {
        'search': search ?? '',
        'carrera': carrera ?? '',
        'promedio': promedio ?? '',
        'page': page.toString(),
      };

      final uri = Uri.parse(
        "${dotenv.env['API_URL']}${dotenv.env['API_LISTA_ALUMNOS']}",
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        alumnos.value = List<Map<String, dynamic>>.from(data['data']);
        currentPage = data['pagination']['current_page'];
        lastPage = data['pagination']['last_page'];

        if (todasCarreras.isEmpty) {
          final Map<int, String> listaCarreras = {};
          for (var alumno in alumnos) {
            final grupos = alumno['grupos'] ?? [];
            if (grupos.isNotEmpty) {
              final carrera = grupos[0]['grupo']['carrera'];
              listaCarreras[carrera['pk_carrera']] = carrera['nombre'];
            }
          }
          todasCarreras.value = listaCarreras;
        }

      } else {
        Get.snackbar(
          'Error',
          'No se pudieron cargar los alumnos',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error de red',
        '$e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void refresh({String? search, String? carrera, String? promedio}) {
    fetchAlumnos(search: search, carrera: carrera, promedio: promedio, page: 1);
  }

  Future<void> deshabilitarAlumno(int idAlumno, context) async {
    var isLoading = false.obs;
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final response = await http.delete(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_DESHABILITAR_ALUMNO']}/$idAlumno'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alumno deshabilitado exitosamente'),
            backgroundColor: Colors.orange,
          ),
        );
        refresh();
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

  Future<void> habilitarAlumno(int idAlumno, context) async {
    var isLoading = false.obs;
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final response = await http.put(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_HABILITAR_ALUMNO']}/$idAlumno'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alumno habilitado exitosamente'),
            backgroundColor: Colors.teal,
          ),
        );
        refresh();
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
