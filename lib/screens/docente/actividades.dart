import 'package:aula_idiomas_app/components/card_actividad_docente.dart';
import 'package:aula_idiomas_app/controllers/ListaActividadesController.dart';
import 'package:aula_idiomas_app/screens/docente/registrar_actividad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActividadesDocente extends StatefulWidget {
  const ActividadesDocente({super.key});

  @override
  State<ActividadesDocente> createState() => _ActividadesDocenteState();
}

class _ActividadesDocenteState extends State<ActividadesDocente> {
  final controller = Get.put(ListaActividadesController());
  String? _search;
  String? _tipo;

  final List<String> _tipos = ['preguntas', 'pdf', 'auditiva'];

  @override
  void initState() {
    super.initState();
    controller.fetchActividades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Actividades', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text('Añade, edita y gestiona las actividades'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar actividad...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                _search = value.trim();
                controller.refresh(search: _search, tipo: _tipo);
              },
            ),
            const SizedBox(height: 13),

            DropdownButtonFormField<String?>(
              value: _tipo,
              hint: const Text('Filtrar por tipo'),
              isExpanded: true,
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Todos'),
                ),
                ..._tipos.map((value) => DropdownMenuItem<String?>(
                      value: value,
                      child: Text(
                        value == 'preguntas'
                            ? 'Preguntas'
                            : value == 'pdf'
                                ? 'Carga de PDF'
                                : 'Auditiva y Oral',
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              ],
              onChanged: (value) {
                setState(() => _tipo = value);
                controller.refresh(search: _search, tipo: _tipo);
              },
            ),
            const SizedBox(height: 13),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Colors.teal));
                }

                if (controller.actividades.isEmpty) {
                  return const Center(child: Text('No hay actividades registradas'));
                }

                return ListView.separated(
                  itemCount: controller.actividades.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final actividad = controller.actividades[index];
                    final bool isActive = actividad['deleted_at'] == null;

                    return CardActividadDocente(
                      pk_actividad: actividad['pk_actividad'],
                      tituloActividad: actividad['nom_actividad'] ?? '',
                      codigo: actividad['cod_actividad'] ?? '',
                      fecha: actividad['fecha_formateada'] ?? '',
                      tipo: actividad['tipo'] == 'preguntas'
                          ? 'Preguntas'
                          : actividad['tipo'] == 'pdf'
                              ? 'Carga de PDF'
                              : 'Auditiva y Oral',
                      descripcion: actividad['descripcion'] ?? '',
                      isActive: isActive,
                      onToggleActive: () async {
                        if (isActive) {
                          await controller.deshabilitarActividad(actividad['pk_actividad'], context);
                        } else {
                          await controller.habilitarActividad(actividad['pk_actividad'], context);
                        }
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CrearActividadDocente(),
            ),
          );

          if (result == true) {
            controller.refresh(search: _search, tipo: _tipo);
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.assignment_add, color: Colors.white),
        tooltip: 'Crear nueva actividad',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
