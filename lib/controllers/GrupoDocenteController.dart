import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grupo_materia.dart';

class GrupoDocenteController extends ChangeNotifier {
  List<GrupoMateria> _grupos = [];
  List<GrupoMateria> _filteredGrupos = [];
  bool _isLoading = false;

  List<GrupoMateria> get grupos => _filteredGrupos;
  bool get isLoading => _isLoading;

  Future<void> fetchGrupos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';
      final id = prefs.getInt('userId')?.toString() ?? '';
      final url = Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_CARGAR_GRUPOS']}=$id');
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['data'];
        _grupos = list.map((e) => GrupoMateria.fromJson(e)).toList();
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
            '${g.grupo.fkCuatrimestre} ${g.grupo.nombre} ${g.grupo.carrera.abreviatura} ${g.grupo.anio}';
        final materiaText = g.materia.nombre;
        return grupoText.toLowerCase().contains(query.toLowerCase()) ||
            materiaText.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
