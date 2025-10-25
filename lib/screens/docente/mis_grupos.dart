import 'package:aula_idiomas_app/components/card_info_grupo_docente.dart';
import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/controllers/GrupoDocenteController.dart';
import 'package:aula_idiomas_app/screens/docente/detalle_grupo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MisGruposDocente extends StatefulWidget {
  const MisGruposDocente({super.key});

  @override
  State<MisGruposDocente> createState() => _MisGruposDocenteState();
}

class _MisGruposDocenteState extends State<MisGruposDocente> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GrupoDocenteController()..fetchGrupos(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Grupos',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Administra las actividades de tus grupos asignados.',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Consumer<GrupoDocenteController>(
                  builder: (context, controller, _) {
                    return InputBuscador(
                      onChanged: controller.buscar,
                    );
                  },
                ),
                const SizedBox(height: 13.0),
                Consumer<GrupoDocenteController>(
                  builder: (context, controller, _) {
                    if (controller.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.teal,
                          ),
                        ),
                      );
                    }

                    if (controller.grupos.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No se encontraron grupos',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      );
                    }

                    return Column(
                      children: controller.grupos.map((g) {
                        return CardInfoGrupoDocente(
                          grupo:
                              '${g.grupo.fkCuatrimestre} ${g.grupo.nombre} ${g.grupo.carrera.abreviatura} ${g.grupo.anio}',
                          cuatri: 'Cuatrimestre: ${g.grupo.fkCuatrimestre}',
                          anio: 'Año escolar: ${g.grupo.anio}',
                          carrera: g.grupo.carrera.nombre,
                          materia: g.materia.nombre,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetalleGrupoScreen(pkGrupo: g.grupo.pkGrupo),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
