import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MisActividadesController {

  Future<Map<String, dynamic>> obtenerActividades() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    final userId = prefs.getInt('userId');
    final url = Uri.parse('http://127.0.0.1:8000/api/alumno/actividades/$userId');

    final respuesta = await http.get(
      url, 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
    );

    if (respuesta.statusCode == 200) {
      return json.decode(respuesta.body);
    } else {
      throw Exception('Error al obtener las actividades');
    }
  }
}
