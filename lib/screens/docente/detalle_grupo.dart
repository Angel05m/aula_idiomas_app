import 'package:aula_idiomas_app/screens/docente/detalle_actividad.dart';
import 'package:aula_idiomas_app/screens/docente/detalle_alumno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
          '${dotenv.env['API_URL']}${dotenv.env['API_DETALLE_GRUPO']}/${widget.pkGrupo}',
        ),
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
            SnackBar(
              content: Text(data['message'] ?? 'Error al cargar el grupo'),
            ),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error de conexión: $e")));
    }
  }

  Future<void> abrirWeb() async {
    final url = dotenv.env['WEB_URL'];

    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("WEB_URL no está definida")));
      return;
    }

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No se pudo abrir la URL")));
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
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.teal),
                        title: Text(
                          '${alumno['nombres'] ?? ''} ${alumno['ap_paterno'] ?? ''} ${alumno['ap_materno'] ?? ''}',
                          style: TextStyle(color: Colors.teal.shade500),
                        ),
                        subtitle: Text(
                          'Matrícula: ${alumno['matricula'] ?? '-'}',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleAlumno(
                                pkAlumno:
                                    grupoData!['alumnos'][index]['pk_alumno'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: grupoData?['actividades']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final act = grupoData!['actividades'][index];
                    final tipo = act['tipo']?.toString().toLowerCase() ?? '';

                    final fechaInicio = act['pivot']?['fecha_inicio'] ?? '-';
                    final fechaFin = act['pivot']?['fecha_fin'] ?? '-';

                    return Card(
                      color: Colors.white,
                      elevation: 3.0,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const Icon(Icons.event, color: Colors.teal),
                        title: Text(
                          act['nom_actividad'] ?? 'Sin título',
                          style: TextStyle(color: Colors.teal),
                        ),
                        subtitle: Text(
                          'Tipo: ${act['tipo'] ?? '-'}\nInicio: $fechaInicio\nFin: $fechaFin',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        onTap: () {
                          if (tipo == 'pdf' ||
                              tipo == 'auditiva' ||
                              tipo == 'audio') {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Contenido no disponible"),
                                content: const Text(
                                  "Para visualizar actividades de tipo PDF o auditiva, por favor ingrese desde la plataforma web.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cerrar"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      abrirWeb();
                                    },
                                    child: const Text("Ir a la Web"),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }
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
              ],
            ),
    );
  }
}
