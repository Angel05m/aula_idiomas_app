import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetalleGrupoScreen extends StatefulWidget {
  final int pkGrupo;

  const DetalleGrupoScreen({super.key, required this.pkGrupo});

  @override
  State<DetalleGrupoScreen> createState() => _DetalleGrupoScreenState();
}

class _DetalleGrupoScreenState extends State<DetalleGrupoScreen>
    with SingleTickerProviderStateMixin {
  bool cargando = true;
  Map<String, dynamic>? grupoData;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    obtenerDetalleGrupo();
  }

  Future<void> obtenerDetalleGrupo() async {
    setState(() => cargando = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final res = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/api/docente/detalle-grupo/${widget.pkGrupo}'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success']) {
          setState(() {
            grupoData = data['data'];
            cargando = false;
          });
        } else {
          setState(() => cargando = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Error al cargar el grupo')),
          );
        }
      } else {
        setState(() => cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al cargar el grupo")),
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
    return Scaffold(
      appBar: AppBar(
                title: Text(
          '${grupoData?['cuatrimestre']?['num_cuatri'] ?? ''} '
          '${grupoData?['nombre'] ?? ''} '
          '${grupoData?['carrera']?['abreviatura'] ?? ''} '
          '${grupoData?['año'] ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.teal,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Participantes'),
            Tab(text: 'Actividades'),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: grupoData?['alumnos']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final alumno = grupoData!['alumnos'][index]['usuario'];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.teal),
                        title: Text(
                            '${alumno['nombres'] ?? '-'} ${alumno['ap_paterno'] ?? '-'} ${alumno['ap_materno'] ?? '-'}'),
                        subtitle: Text('Matrícula: ${alumno['matricula'] ?? '-'}'),
                      ),
                    );
                  },
                ),

                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: grupoData?['actividades']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final act = grupoData!['actividades'][index];

                    final fechaInicio = act['pivot']?['fecha_inicio'] ?? '-';
                    final fechaFin = act['pivot']?['fecha_fin'] ?? '-';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Colors.teal),
                        title: Text(act['nom_actividad'] ?? 'Sin título'),
                        subtitle: Text('Tipo: ${act['tipo'] ?? '-'}\nInicio: $fechaInicio\nFin: $fechaFin'),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
