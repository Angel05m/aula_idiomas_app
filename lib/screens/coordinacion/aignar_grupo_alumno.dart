import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aula_idiomas_app/components/input_buscador.dart';

class AsignarGrupoAlumno extends StatefulWidget {
  final String pk_grupo;

  const AsignarGrupoAlumno({super.key, required this.pk_grupo});

  @override
  State<AsignarGrupoAlumno> createState() => _AsignarGrupoAlumnoState();
}

class _AsignarGrupoAlumnoState extends State<AsignarGrupoAlumno> {
  List alumnos = [];
  List alumnosFiltrados = [];
  List seleccionados = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    obtenerAlumnos();
  }

  Future<void> obtenerAlumnos() async {
    setState(() => cargando = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final res = await http.get(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_OBTENER_ALUMNOS']}'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          alumnos = data['data'];
          alumnosFiltrados = alumnos;
          cargando = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ${res.statusCode}: no se pudieron obtener los alumnos'),
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

  void filtrarAlumnos(String texto) {
    setState(() {
      alumnosFiltrados = alumnos.where((alumno) {
        final nombreCompleto =
            "${alumno['usuario']['nombres']} ${alumno['usuario']['ap_paterno']} ${alumno['usuario']['ap_materno'] ?? ''}"
                .toLowerCase();

        String grupoActual = "";
        if (alumno['grupos'] != null && alumno['grupos'].isNotEmpty) {
          final grupo = alumno['grupos'][0]['grupo'];
          final carrera = grupo['carrera'];
          grupoActual =
              "${grupo['fk_cuatrimestre']}${grupo['nombre']}${carrera['abreviatura']} ${grupo['año']}"
                  .toLowerCase();
        }

        final filtro = texto.toLowerCase();
        return nombreCompleto.contains(filtro) || grupoActual.contains(filtro);
      }).toList();
    });
  }

  Future<void> asignarGrupo() async {
    if (seleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    final res = await http.post(
      Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_ASIGNAR_GRUPO']}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        'fk_grupo': widget.pk_grupo,
        'alumnos': seleccionados,
      }),
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grupo asignado correctamente.'),
          backgroundColor: Colors.teal,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al asignar el grupo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildAlumnosCard(Map alumno) {
    final isSelected = seleccionados.contains(alumno['fk_usuario']);

    String grupoActual = "Sin grupo asignado";
    if (alumno['grupos'] != null && alumno['grupos'].isNotEmpty) {
      final grupo = alumno['grupos'][0]['grupo'];
      final carrera = grupo['carrera'];
      grupoActual =
          "${grupo['fk_cuatrimestre']}${grupo['nombre']}${carrera['abreviatura']} ${grupo['año']}";
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        activeColor: Colors.teal,
        checkColor: Colors.white,
        value: isSelected,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${alumno['usuario']['nombres']} ${alumno['usuario']['ap_paterno']} ${alumno['usuario']['ap_materno'] ?? ''}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              grupoActual,
              style: TextStyle(
                color: grupoActual == "Sin grupo asignado"
                    ? Colors.grey
                    : Colors.black87,
                fontSize: 13,
              ),
            ),
          ],
        ),
        onChanged: (val) {
          setState(() {
            if (val == true) {
              seleccionados.add(alumno['fk_usuario']);
            } else {
              seleccionados.remove(alumno['fk_usuario']);
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
          "Asignar Grupo",
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
                    "Selecciona los alumnos:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  InputBuscador(onChanged: filtrarAlumnos),
                  const SizedBox(height: 16),

                  ...alumnosFiltrados.map((g) => buildAlumnosCard(g)).toList(),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: asignarGrupo,
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
