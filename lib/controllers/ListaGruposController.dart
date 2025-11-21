import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grupo_materia.dart';

class ListaGruposController extends ChangeNotifier {
  List<Grupo> _grupos = [];
  List<Grupo> _filteredGrupos = [];
  bool _isLoading = false;

  List<Grupo> get grupos => _filteredGrupos;
  bool get isLoading => _isLoading;

  Future<void> fetchGrupos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';
      final url = Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_LISTA_GRUPOS']}');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['data']['data'];
        _grupos = list.map((e) => Grupo.fromJson(e)).toList();
        _filteredGrupos = _grupos;
      } else {
        throw Exception('Error al cargar los grupos');
      }
    } catch (e) {
      debugPrint('Error fetchGrupos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void buscar(String query) {
    if (query.isEmpty) {
      _filteredGrupos = _grupos;
    } else {
      _filteredGrupos = _grupos.where((g) {
        final grupoText =
            '${g.fkCuatrimestre} ${g.nombre} ${g.carrera.abreviatura} ${g.anio}';
        return grupoText.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> toggleGrupoStatus(int id, bool isDisabled, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      final url = Uri.parse(
        '${dotenv.env['API_URL']}${dotenv.env['API_CAMBIAR_ESTATUS']}/$id/${isDisabled ? 'habilitar' : 'deshabilitar'}',
      );

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Estatus actualizado exitosamente'),
            backgroundColor: Colors.teal,
          ),
        );
        await fetchGrupos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cambiar el estado del grupo'),
            backgroundColor: Color.fromARGB(255, 150, 7, 0),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error toggleGrupoStatus: $e');
    }
  }

}
