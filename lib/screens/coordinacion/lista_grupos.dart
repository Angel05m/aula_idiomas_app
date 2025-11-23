import 'package:aula_idiomas_app/components/card_info_grupo.dart';
import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/controllers/ListaGruposController.dart';
import 'package:aula_idiomas_app/screens/coordinacion/registrar_grupo.dart';
import 'package:aula_idiomas_app/screens/docente/detalle_grupo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaGrupos extends StatefulWidget {
  const ListaGrupos({super.key});

  @override
  State<ListaGrupos> createState() => _ListaGruposState();
}

class _ListaGruposState extends State<ListaGrupos> {
  late ListaGruposController listaGruposController;

  @override
  void initState() {
    super.initState();
    listaGruposController = ListaGruposController();
    listaGruposController.fetchGrupos();
  }

  void _mostrarAlertaGrupoDeshabilitado(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Grupo deshabilitado'),
          content: const Text(
              'Este grupo está deshabilitado, por lo que no es posible ver su información.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: listaGruposController,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        'Añade, edita y gestiona la información de los Grupos',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                Consumer<ListaGruposController>(
                  builder: (context, controller, _) {
                    return InputBuscador(
                      onChanged: controller.buscar,
                    );
                  },
                ),

                const SizedBox(height: 13.0),

                Consumer<ListaGruposController>(
                  builder: (context, controller, _) {
                    if (controller.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.teal),
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
                        final isDisabled = g.deletedAt != null;

                        return CardInfoGrupo(
                          pk_grupo: g.pkGrupo,
                          grupo:
                              '${g.fkCuatrimestre}${g.nombre}${g.carrera.abreviatura} ${g.anio}',
                          cuatri: 'Cuatrimestre: ${g.fkCuatrimestre}',
                          anio: 'Año escolar: ${g.anio}',
                          carrera: g.carrera.nombre,
                          isDisabled: isDisabled,
                          onTap: () {
                            if (isDisabled) {
                              _mostrarAlertaGrupoDeshabilitado(context);
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetalleGrupoScreen(pkGrupo: g.pkGrupo),
                              ),
                            );
                          },
                          onToggleStatus: () async {
                            await controller.toggleGrupoStatus(
                              g.pkGrupo,
                              isDisabled,
                              context,
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 13.0),
              ],
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrarGrupo(
                  listaGruposController: listaGruposController,
                ),
              ),
            );
            
            if (result == true) {
              await listaGruposController.fetchGrupos();
            }
          },
          backgroundColor: Colors.teal,
          child: const Icon(Icons.group_add, color: Colors.white),
          tooltip: 'Agregar nuevo grupo',
          elevation: 5,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
