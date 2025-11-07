import 'package:aula_idiomas_app/components/card-button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detalle_grupo_alumno.dart';

class InicioAlumnos extends StatefulWidget {
  const InicioAlumnos({super.key});

  @override
  State<InicioAlumnos> createState() => _InicioAlumnosState();
}

class _InicioAlumnosState extends State<InicioAlumnos> {
  bool cargando = true;
  List grupos = [];

  int totalPendientes = 0;
  int totalEntregadas = 0;
  int totalNoEntregadas = 0;

  @override
  void initState() {
    super.initState();
    obtenerGrupos();
  }

  Future<void> obtenerGrupos() async {
    setState(() => cargando = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    final userId = prefs.getInt('userId') ?? 0;

    try {
      final res = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/alumno/inicio/$userId'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final gruposData = List<Map<String, dynamic>>.from(data['grupos'] ?? []);

        gruposData.sort((a, b) {
          final eliminadoA = a['deleted_at'] != null;
          final eliminadoB = b['deleted_at'] != null;
          return eliminadoA ? 1 : (eliminadoB ? -1 : 0);
        });

        int pendientes = 0;
        int entregadas = 0;
        int noEntregadas = 0;

        for (var g in gruposData) {
          final resumen = g['resumen_actividades'] ?? {};
          pendientes += ((resumen['pendientes'] ?? 0) as num).toInt();
          entregadas += ((resumen['entregadas'] ?? 0) as num).toInt();
          noEntregadas += ((resumen['no_entregadas'] ?? 0) as num).toInt();
        }


        setState(() {
          grupos = gruposData;
          totalPendientes = pendientes;
          totalEntregadas = entregadas;
          totalNoEntregadas = noEntregadas;
          cargando = false;
        });
      } else {
        setState(() => cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener grupos (${res.statusCode})')),
        );
      }
    } catch (e) {
      setState(() => cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  Widget buildCardGrupo(Map grupoData) {
    final grupo = grupoData['grupo'];
    final carrera = grupo?['carrera'];
    final eliminado = grupoData['deleted_at'] != null;
    final resumen = grupoData['resumen_actividades'] ?? {};

    String nombreGrupo = 'Sin nombre';
    if (grupo != null) {
      nombreGrupo =
          "${grupo['fk_cuatrimestre']}${grupo['nombre']}${carrera?['abreviatura'] ?? ''} ${grupo['año']}";
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleGrupoAlumno(
              grupo: grupo,
              esPasado: eliminado,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: eliminado ? Colors.grey[300] : Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: eliminado ? Colors.grey : Colors.teal,
            child: const Icon(Icons.group, color: Colors.white),
          ),
          title: Text(
            nombreGrupo,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: eliminado ? Colors.grey[700] : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eliminado ? 'Grupo anterior' : 'Grupo actual',
                style: TextStyle(
                  color: eliminado ? Colors.grey[600] : Colors.teal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pendientes: ${resumen['pendientes'] ?? 0} | '
                'Entregadas: ${resumen['entregadas'] ?? 0} | '
                'No entregadas: ${resumen['no_entregadas'] ?? 0}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          trailing: eliminado
              ? null
              : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenido/a',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Alumno, ¡a seguir aprendiendo!',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CardButton(
                          titulo: 'Pendientes',
                          valor: totalPendientes,
                          icono: Icons.timelapse,
                          iconBackground: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CardButton(
                          titulo: 'Finalizadas',
                          valor: totalEntregadas,
                          icono: Icons.check,
                          iconBackground: Colors.green,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CardButton(
                          titulo: 'No entregadas',
                          valor: totalNoEntregadas,
                          icono: Icons.timer_off,
                          iconBackground: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Mis grupos:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  grupos.isEmpty
                      ? const Center(
                          child: Text(
                            "No se encontraron grupos asignados.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Column(
                          children: grupos.map((g) => buildCardGrupo(g)).toList(),
                        ),
                ],
              ),
            ),
    );
  }
}
