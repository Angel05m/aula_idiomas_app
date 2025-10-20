import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var isLoadingPerfil = false.obs;
  var hasError = false.obs;
  var userData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadPerfil();
  }

  Future<void> loadPerfil() async {
    try {
      isLoadingPerfil.value = true;
      hasError.value = false;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Ocurrió un error inesperado',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        hasError.value = true;
        isLoadingPerfil.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userData.value = data;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al cargar el perfil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      hasError.value = true;
    } finally {
      isLoadingPerfil.value = false;
    }
  }
}
