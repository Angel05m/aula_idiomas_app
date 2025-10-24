import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ActividadController {

  Future<Map<String, dynamic>> guardarActividad({
    required String titulo,
    required String descripcion,
    required String tipoActividad,
    required List<Map<String, dynamic>> preguntas,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';
      final userId = prefs.getInt('userId') ?? 0;

      final data = {
        "nom_actividad": titulo,
        "descripcion": descripcion,
        "tipo_actividad": tipoActividad.toLowerCase(),
        "fk_usuario": userId, 
        "preguntas": preguntas,
      };

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/docente/guardar-actividad-preguntas'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", 
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Error en la petición: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error al conectar con el servidor: $e"
      };
    }
  }
}
