import 'package:aula_idiomas_app/components/card_info_alumno.dart';
import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/controllers/AlumnosController.dart';
import 'package:aula_idiomas_app/screens/coordinacion/registro_alumno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListaAlumnos extends StatefulWidget {
  const ListaAlumnos({super.key});

  @override
  State<ListaAlumnos> createState() => _ListaAlumnosState();
}

class _ListaAlumnosState extends State<ListaAlumnos> {
  final AlumnosController controller = Get.put(AlumnosController());

  int? _selectedOptionC; 
  String? _selectedOptionP; 
  String? _search;

  final List<String> _optionsP = ['10', '9', '8', '7', '6'];

  @override
  void initState() {
    super.initState();
    controller.fetchAlumnos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alumnos', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text(
                    'Añade, edita y gestiona la información de los alumnos',
                    style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            InputBuscador(
              onChanged: (String? value) {
                _search = value;
                controller.refresh(
                  search: _search,
                  carrera: _selectedOptionC?.toString(),
                  promedio: _selectedOptionP,
                );
              },
            ),
            const SizedBox(height: 13.0),

            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Obx(() {
                    final carrerasMap = controller.todasCarreras;
                    return DropdownButtonFormField<int?>(
                      value: _selectedOptionC,
                      hint: const Text('Selecciona Carrera'),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Todos'),
                        ),
                        ...carrerasMap.entries.map((entry) => DropdownMenuItem<int?>(
                              value: entry.key,
                              child: Text(entry.value, overflow: TextOverflow.ellipsis),
                            )),
                      ],
                      onChanged: (int? value) {
                        setState(() => _selectedOptionC = value);
                        controller.refresh(
                          search: _search,
                          carrera: _selectedOptionC?.toString(),
                          promedio: _selectedOptionP,
                        );
                      },
                    );
                  }),
                ),

                const SizedBox(width: 10),

                Flexible(
                  flex: 1,
                  child: DropdownButtonFormField<String?>(
                    value: _selectedOptionP,
                    hint: const Text('Promedio'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Todos'),
                      ),
                      ..._optionsP.map((value) => DropdownMenuItem<String?>(
                            value: value,
                            child: Text(value, overflow: TextOverflow.ellipsis),
                          )),
                    ],
                    onChanged: (String? value) {
                      setState(() => _selectedOptionP = value);
                      controller.refresh(
                        search: _search,
                        carrera: _selectedOptionC?.toString(),
                        promedio: _selectedOptionP,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13.0),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Colors.teal));
                }

                if (controller.alumnos.isEmpty) {
                  return const Center(child: Text('No hay alumnos registrados'));
                }

                return ListView.separated(
                  itemCount: controller.alumnos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final alumno = controller.alumnos[index];
                    final usuario = alumno['usuario'] ?? {};
                    final grupos = alumno['grupos'] ?? [];
                    final carrera = grupos.isNotEmpty
                        ? grupos[0]['grupo']['carrera']['nombre']
                        : 'Sin Carrera';

                    final bool isActive = usuario['deleted_at'] == null;

                    return CardInfoAlumno(
                      idAlumno: usuario['pk_usuario'],
                      nombreA:
                          '${usuario['nombres'] ?? ''} ${usuario['ap_paterno'] ?? ''} ${usuario['ap_materno'] ?? ''}',
                      matricula: usuario['matricula'] ?? '',
                      promedio: alumno['promedio'] ?? 0,
                      carrera: carrera,
                      isActive: isActive,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegistroAlumno()),
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add_circle, color: Colors.white),
        tooltip: 'Agregar nuevo alumno',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
