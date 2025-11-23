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
  Map<String, List> grupos = {};
  Map<String, List> gruposFiltrados = {};
  List<int> seleccionados = [];

  Map<String, bool> grupoSeleccionado = {};

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
        Uri.parse('${dotenv.env['API_URL']}${dotenv.env['API_OBTENER_ALUMNOS_POR_GRUPOS']}'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final Map<String, List> g = Map<String, List>.from(data['data']);

        g.forEach((grupo, alumnos) {
          grupoSeleccionado[grupo] = false;

          for (var alumno in alumnos) {
            seleccionados.remove(alumno['pk_usuario']);
          }
        });

        setState(() {
          grupos = g;
          gruposFiltrados = Map.from(g);
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
    if (texto.isEmpty) {
      setState(() => gruposFiltrados = Map.from(grupos));
      return;
    }

    final filtro = texto.toLowerCase();
    final Map<String, List> resultado = {};

    grupos.forEach((grupoNombre, alumnosGrupo) {
      final alumnosFiltrados = alumnosGrupo.where((alumno) {
        final nombre = "${alumno['nombres']} ${alumno['ap_paterno']} ${alumno['ap_materno'] ?? ''}"
            .toLowerCase();

        return nombre.contains(filtro) || grupoNombre.toLowerCase().contains(filtro);
      }).toList();

      if (alumnosFiltrados.isNotEmpty) {
        resultado[grupoNombre] = alumnosFiltrados;
      }
    });

    setState(() => gruposFiltrados = resultado);
  }

  void seleccionarGrupo(String grupo, bool valor) {
    final alumnos = grupos[grupo] ?? [];

    setState(() {
      grupoSeleccionado[grupo] = valor;

      for (var al in alumnos) {
        final id = al['pk_usuario'];

        if (valor) {
          if (!seleccionados.contains(id)) {
            seleccionados.add(id);
          }
        } else {
          seleccionados.remove(id);
        }
      }
    });
  }

  Widget buildAlumnoCard(Map alumno, String grupoNombre) {
    final id = alumno['pk_usuario'];
    final isSelected = seleccionados.contains(id);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: CheckboxListTile(
        activeColor: Colors.teal,
        value: isSelected,
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          "${alumno['nombres']} ${alumno['ap_paterno']} ${alumno['ap_materno'] ?? ''}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        onChanged: (v) {
          setState(() {
            if (v == true) {
              seleccionados.add(id);
            } else {
              seleccionados.remove(id);
            }

            final alumnosGrupo = grupos[grupoNombre]!;
            final todos = alumnosGrupo.every((a) => seleccionados.contains(a['pk_usuario']));

            grupoSeleccionado[grupoNombre] = todos;
          });
        },
      ),
    );
  }

  Future<void> asignarGrupo() async {
    if (seleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona al menos un alumno.")),
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
            backgroundColor: Colors.teal),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al asignar el grupo.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asignar Grupo", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Busca alumnos:", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  InputBuscador(onChanged: filtrarAlumnos),
                  const SizedBox(height: 20),

                  ...gruposFiltrados.entries.map((entry) {
                    final grupoNombre = entry.key;
                    final alumnos = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$grupoNombre',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),

                        CheckboxListTile(
                          value: grupoSeleccionado[grupoNombre] ?? false,
                          title: const Text("Seleccionar todo el grupo"),
                          activeColor: Colors.teal,
                          onChanged: (v) => seleccionarGrupo(grupoNombre, v ?? false),
                        ),

                        alumnos.isNotEmpty
                            ? Column(
                                children: alumnos
                                    .map((al) => buildAlumnoCard(al, grupoNombre))
                                    .toList(),
                              )
                            : const Text("Sin alumnos"),

                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),

                  ElevatedButton(
                    onPressed: asignarGrupo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child:
                        const Text("Guardar asignación", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }
}
