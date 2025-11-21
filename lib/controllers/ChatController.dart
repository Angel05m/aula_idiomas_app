import 'dart:convert';
import 'package:aula_idiomas_app/models/usuario.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatController {
  static final String baseUrl = "${dotenv.env['API_URL']}${dotenv.env['API_CHAT']}";

  static Future<Map<String, List<Usuario>>> obtenerHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    final id = prefs.getInt('userId')?.toString() ?? '';

    final url = Uri.parse("$baseUrl/${dotenv.env['API_CHAT_HISTORIAL']}/$id");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final data = jsonDecode(response.body);

    final List<Usuario> contactos = (data["contactos"] as List)
        .map((e) => Usuario.fromJson(e))
        .toList();

    final List<Usuario> usuarios = (data["usuarios"] as List)
        .map((e) => Usuario.fromJson(e))
        .toList();

    return {
      "contactos": contactos,
      "usuarios": usuarios,
    };
  }

  static Future<List<dynamic>> obtenerMensajes(int idContacto) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    final idPropio = prefs.getInt('userId')?.toString() ?? '';
    final url = Uri.parse("$baseUrl/${dotenv.env['API_CHAT_MENSAJES']}/$idPropio/${dotenv.env['API_CHAT_CONTACTO']}/$idContacto");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final data = jsonDecode(response.body);

    return data["data"];
  }

  static Future<bool> enviarMensaje({
    required int paraUsuario,
    required String mensaje,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    final deUsuario = prefs.getInt('userId')?.toString() ?? '';
    final url = Uri.parse("$baseUrl/${dotenv.env['API_CHAT_ENVIAR_MENSAJE']}");

    final response = await http.post(
      url,
      body: jsonEncode({
        "de_usuario": deUsuario,
        "para_usuario": paraUsuario,
        "mensaje": mensaje,
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(response.body);
    return data["success"] == true;
  }
}
