import 'dart:convert';
import 'package:aula_idiomas_app/controllers/ListaGruposController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GrupoCoordinadorController {
  final ListaGruposController listaGruposController;

  GrupoCoordinadorController({required this.listaGruposController});

  Future<void> crearGrupo({
    required BuildContext context,
    required String nombre,
    required String anio,
    required String fkCarrera,
    required String fkCuatrimestre,
    required String fkMateria,
    required String fkDocente,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';
      final url = Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_CREAR_GRUPO']}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nombre': nombre,
          'año': anio,
          'fk_carrera': fkCarrera,
          'fk_cuatrimestre': fkCuatrimestre,
          'fk_materia': fkMateria,
          'fk_docente': fkDocente,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Grupo creado exitosamente'),
            backgroundColor: Colors.teal,
          ),
        );

        await listaGruposController.fetchGrupos();

        Navigator.pop(context, true);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear el grupo: ${response.body}'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red[900],
        ),
      );
    }
  }
}
