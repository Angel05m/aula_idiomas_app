import 'package:aula_idiomas_app/components/card_info_grupo.dart';
import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/screens/coordinacion/registrar_grupo.dart';
import 'package:flutter/material.dart';

class ListaGrupos extends StatefulWidget {
  const ListaGrupos({super.key});

  @override
  State<ListaGrupos> createState() => _ListaGruposState();
}

class _ListaGruposState extends State<ListaGrupos> {
  String? _selectedOptionC;
  String? _selectedOptionCT;

  final List<String> _optionsC = [
    'Añade, edita y gestiona la información de los alumnos',
    'Option B',
    'Option C',
  ];
  final List<String> _optionsCT = ['1', '2', '3', '4', '5', '6', '7', '8'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grupos',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text('Añade, edita y gestiona la información de los Grupos'),
                ],
              ),
              const SizedBox(height: 20.0),
              const InputBuscador(),
              const SizedBox(height: 13.0),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12.0),
                      isExpanded: true,
                      value: _selectedOptionC,
                      decoration: InputDecoration(
                        hintText: 'Selecciona Carrera',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            width: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.teal,
                            width: 3.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: Text('Selecciona Carrera'),
                      onChanged: (String? newValueC) {
                        setState(() {
                          _selectedOptionC = newValueC;
                        });
                      },
                      items: _optionsC.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12.0),
                      isExpanded: true,
                      value: _selectedOptionCT,
                      decoration: InputDecoration(
                        hintText: 'Cuatrimestre',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            width: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.teal,
                            width: 3.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      hint: Text('Cuatrimestre'),
                      onChanged: (String? newValueP) {
                        setState(() {
                          _selectedOptionCT = newValueP;
                        });
                      },
                      items: _optionsCT.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13.0),
              Column(
                children: [
                  CardInfoGrupo(
                    grupo: '1 A ITIID 2025',
                    cuatri: 'Cuatrimestre: 1',
                    anio: 'Año escolar: 2025',
                    carrera: 'Ingeniería en Tecnologías de la Información e Innovación Digital',
                  ),
                ],
              ),
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
    );
  }
}
