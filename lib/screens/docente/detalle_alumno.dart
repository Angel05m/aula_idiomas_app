import 'dart:convert';

import 'package:aula_idiomas_app/screens/docente/detalle_actividad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetalleAlumno extends StatefulWidget {
  final int pkAlumno;

  const DetalleAlumno({super.key, required this.pkAlumno});

  @override
  State<DetalleAlumno> createState() => _DetalleAlumnoState();
}

class _DetalleAlumnoState extends State<DetalleAlumno> {
  bool cargando = true;
  Map<String, dynamic>? alumnoData;

  @override
  void initState() {
    super.initState();
    obtenerDetalleAlumno();
  }

  Future<void> obtenerDetalleAlumno() async {
    setState(() => cargando = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final res = await http.get(
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_DETALLE_ALUMNO']}/${widget.pkAlumno}'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success']) {
          setState(() {
            alumnoData = data['data'];
            cargando = false;
          });
        } else {
          setState(() => cargando = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Error al cargar el alumno')),
          );
        }
      } else {
        setState(() => cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al obtener detalles del alumno")),
        );
      }
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.teal)),
      );
    }

    if (alumnoData == null) {
      return const Scaffold(
        body: Center(child: Text('No se pudo cargar el alumno')),
      );
    }

    final alumno = alumnoData!['alumno'];
    final grupo = alumnoData!['grupo'];
    final actividades = alumnoData!['actividades'] ?? [];

    final nombreCompleto =
        '${alumno['nombres'] ?? '-'} ${alumno['ap_paterno'] ?? '-'} ${alumno['ap_materno'] ?? ''}';

    return Scaffold(
      appBar: AppBar(
        title: Text(nombreCompleto),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Información personal',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            Text('Matrícula: ${alumno['matricula'] ?? '-'}'),
            const SizedBox(height: 16),
            Text('Grupo',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            Text('${grupo['cuatrimestre']?['num_cuatri'] ?? '-'} ${grupo['nombre'] ?? '-'} ${grupo['carrera']?['abreviatura'] ?? '-'} ${grupo['año'] ?? '-'}'),
            Text('${grupo['carrera']?['nombre'] ?? '-'}'),
            const SizedBox(height: 16),
            Text('Actividades',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: actividades.length,
                itemBuilder: (context, index) {
                  final act = actividades[index];
                  final entregado = act['entregado'] ?? false;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(
                        entregado ? Icons.check_circle : Icons.cancel,
                        color: entregado ? Colors.green : Colors.red,
                      ),
                      title: Text(act['nom_actividad'] ?? '-'),
                      subtitle: Text(entregado ? 'Entregado' : 'Pendiente'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleActividad(
                              pkActividad: act['pk_actividad'],
                              nombreActividad: act['nom_actividad'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
