import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoadingLogin = false.obs;
  var isLoadingGoogle = false.obs;

  var hasError = false.obs;
  var userData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '226147543177-r63get0uoqjpkk6t8k6p8jbmds9jq7fa.apps.googleusercontent.com'
        : null,
    scopes: ['email'],
  );

  Future<void> login(String matricula, String password, context) async {
    if (matricula.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Campos requeridos',
        'Ingresa matrícula y contraseña',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingLogin.value = true;
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/login');
      var response = await http.post(
        url,
        body: {'matricula': matricula, 'password': password},
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final token = data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', token);
        await prefs.setInt('userId', data['user']['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bienvenido/a!'),
            backgroundColor: Colors.teal,
          ),
        );

        Get.offNamed('/alumno/inicio');
      } else {
        Get.snackbar(
          'Error de autenticación',
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
      isLoadingLogin.value = false;
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      isLoadingGoogle.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoadingGoogle.value = false;
        Get.snackbar(
          'Error',
          'Login cancelado por el usuario',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final email = googleUser.email;

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login-google'),
        body: {'email': email},
      );

      isLoadingGoogle.value = false;

      Map<String, dynamic> data;
      try {
        data = json.decode(response.body);
      } catch (_) {
        Get.snackbar(
          'Error',
          'Respuesta inválida del servidor',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (response.statusCode == 200 &&
          data['success'] == true &&
          data['user'] != null) {
        final token = data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', token);

        final user = data['user'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bienvenido/a!'),
            backgroundColor: Colors.teal,
          ),
        );

        switch (user['rol']) {
          case 2:
            Get.offAllNamed('/docente/inicio');
            break;
          case 3:
            Get.offAllNamed('/coordinacion/inicio');
            break;
          default:
            Get.snackbar(
              'Error',
              'Rol no autorizado',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
        }
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Ocurrió un error desconocido',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingGoogle.value = false;
      Get.snackbar(
        'Error',
        'Error al iniciar sesión con Google: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      var data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Vuelve pronto!'),
            backgroundColor: Colors.teal,
          ),
        );

        Get.offNamed('/login');
      } else {
        Get.snackbar(
          'Error',
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
    }
  }
}
