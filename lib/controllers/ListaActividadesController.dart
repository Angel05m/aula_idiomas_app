import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListaActividadesController extends GetxController {
  var isLoading = false.obs;
  var actividades = <Map<String, dynamic>>[].obs;

  var currentPage = 1;
  var lastPage = 1;

  Future<void> fetchActividades({String? search, String? tipo, int page = 1}) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final queryParams = {
        'search': search ?? '',
        'tipo': tipo ?? '',
        'page': page.toString(),
      };

      final baseUrl = "${dotenv.env['API_URL']}${dotenv.env['API_CARGAR_ACTIVIDADES']}";

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        actividades.value = List<Map<String, dynamic>>.from(data['data']);
        currentPage = data['pagination']['current_page'];
        lastPage = data['pagination']['last_page'];
      } else {
        Get.snackbar('Error', 'No se pudieron cargar las actividades',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error de red', '$e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void refresh({String? search, String? tipo}) {
    fetchActividades(search: search, tipo: tipo, page: 1);
  }

  Future<void> deshabilitarActividad(int id, context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final response = await http.delete(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_DESHABILITAR_ACTIVIDAD']}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.orange),
        );
        refresh();
      } else {
        Get.snackbar('Error', data['message'] ?? 'Ocurrió un error', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error de red', '$e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> habilitarActividad(int id, context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final response = await http.put(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_HABILITAR_ACTIVIDAD']}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.teal),
        );
        refresh();
      } else {
        Get.snackbar('Error', data['message'] ?? 'Ocurrió un error', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error de red', '$e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
