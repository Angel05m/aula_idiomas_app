import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AsignarActividadDocente extends StatefulWidget {
  final String pk_actividad;

  const AsignarActividadDocente({super.key, required this.pk_actividad});

  @override
  State<AsignarActividadDocente> createState() =>
      _AsignarActividadDocenteState();
}

class _AsignarActividadDocenteState extends State<AsignarActividadDocente> {
  List grupos = [];
  List seleccionados = [];
  DateTime? fechaInicio;
  DateTime? fechaFin;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    obtenerGrupos();
  }

  Future<void> obtenerGrupos() async {
    setState(() => cargando = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final res = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/docente/grupos-actividad'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          grupos = data['data'];
          cargando = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ${res.statusCode}: no se pudieron obtener los grupos'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => cargando = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => cargando = false);
    }
  }

  Future<void> asignarActividad() async {
    if (fechaInicio == null || fechaFin == null || seleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    final res = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/docente/asignar-actividad'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'fk_actividad': widget.pk_actividad,
        'grupos': seleccionados,
        'fecha_inicio': fechaInicio!.toIso8601String(),
        'fecha_fin': fechaFin!.toIso8601String(),
      }),
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Actividad asignada correctamente.'),
          backgroundColor: Colors.teal,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al asignar la actividad.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildGrupoCard(Map grupo) {
    final isSelected = seleccionados.contains(grupo['pk_grupo']);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        activeColor: Colors.teal,
        checkColor: Colors.white,
        value: isSelected,
        title: Text(
          grupo['nombre'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        subtitle: Text(
          "Año: ${grupo['año']}",
          style: const TextStyle(color: Colors.teal),
        ),
        onChanged: (val) {
          setState(() {
            if (val == true) {
              seleccionados.add(grupo['pk_grupo']);
            } else {
              seleccionados.remove(grupo['pk_grupo']);
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Asignar Actividad",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade100,
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selecciona los grupos:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...grupos.map((g) => buildGrupoCard(g)).toList(),
                  const SizedBox(height: 20),
                  const Text(
                    "Fecha de inicio:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DateTimeFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      suffixIcon: const Icon(Icons.event, color: Colors.teal),
                    ),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    onChanged: (DateTime? value) {
                      fechaInicio = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Fecha de fin:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DateTimeFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      suffixIcon: const Icon(Icons.event, color: Colors.teal),
                    ),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    onChanged: (DateTime? value) {
                      fechaFin = value;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: asignarActividad,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      "Guardar asignación",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
