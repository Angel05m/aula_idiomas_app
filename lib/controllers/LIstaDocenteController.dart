import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ListaDocenteController extends GetxController {
  var docentes = <dynamic>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var hasMore = true.obs;

  var searchQuery = ''.obs;

  Future<void> fetchDocentes({bool refresh = false}) async {
    try {
      if (refresh) {
        docentes.clear();
        currentPage.value = 1;
        hasMore.value = true;
      }

      if (!hasMore.value) return;

      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final url = Uri.parse(
        '${dotenv.env['API_URL']}${dotenv.env['API_LISTA_DOCENTES']}?page=${currentPage.value}&search=${searchQuery.value}',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> nuevosDocentes = data['data'] ?? [];
        final pagination = data['pagination'] ?? {};

        currentPage.value = pagination['current_page'] ?? 1;
        lastPage.value = pagination['last_page'] ?? 1;

        if (currentPage.value >= lastPage.value || nuevosDocentes.isEmpty) {
          hasMore.value = false;
        } else {
          hasMore.value = true;
          currentPage.value++;
        }

        docentes.addAll(nuevosDocentes);
      } else {
        Get.snackbar(
          'Error',
          'Error al obtener docentes (${response.statusCode})',
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
      isLoadingMore.value = false;
    }
  }

  Future<void> searchDocentes(String query) async {
    searchQuery.value = query;
    await fetchDocentes(refresh: true);
  }

  Future<void> refreshDocentes() async {
    await fetchDocentes(refresh: true);
  }
}
