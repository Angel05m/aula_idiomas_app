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
  // String? _selectedOptionC;
  // String? _selectedOptionCT;

  // final List<String> _optionsC = [
  //   'Añade, edita y gestiona la información de los alumnos',
  //   'Option B',
  //   'Option C',
  // ];
  // final List<String> _optionsCT = ['1', '2', '3', '4', '5', '6', '7', '8'];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListaGruposController()..fetchGrupos(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
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
                        return CardInfoGrupo(
                          grupo: '${g.fkCuatrimestre}${g.nombre}${g.carrera.abreviatura} ${g.anio}',
                          cuatri: 'Cuatrimestre: ${g.fkCuatrimestre}',
                          anio: 'Año escolar: ${g.anio}',
                          carrera: g.carrera.nombre,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetalleGrupoScreen(pkGrupo: g.pkGrupo),
                              ),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrarGrupo()),
            );
          },
          backgroundColor: Colors.teal,
          child: Icon(Icons.group_add, color: Colors.white),
          tooltip: 'Agregar nuevo docente',
          elevation: 5,
        ),
        // Boton flotante
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      )
      );
  }
}
