import 'package:aula_idiomas_app/components/card_info_alumno.dart';
import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/screens/coordinacion/registro_alumno.dart';
import 'package:flutter/material.dart';

class ListaAlumnos extends StatefulWidget {
  const ListaAlumnos({super.key});

  @override
  State<ListaAlumnos> createState() => _ListaAlumnosState();
}

class _ListaAlumnosState extends State<ListaAlumnos> {
  String? _selectedOptionC;
  String? _selectedOptionP;

  List<String> _optionsC = [
    'Añade, edita y gestiona la información de los alumnos',
    'Option B',
    'Option C',
  ];
  List<String> _optionsP = ['9', '8', '7'];

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
                    'Alumnos',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text('Añade, edita y gestiona la información de los alumnos'),
                ],
              ),
              const SizedBox(height: 20.0),
              const InputBuscador(),
              const SizedBox(height: 13.0),
              // Input de seleccion
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
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12.0),
                      isExpanded: true,
                      value: _selectedOptionP,
                      decoration: InputDecoration(
                        hintText: 'Promedio',
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
                      hint: Text('Promedio'),
                      onChanged: (String? newValueP) {
                        setState(() {
                          _selectedOptionP = newValueP;
                        });
                      },
                      items: _optionsP.map((String value) {
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
                  CardInfoAlumno(
                    nombreA: 'Angel Ariel Salazar Medina',
                    matricula: '202200412',
                    promedio: 0,
                    carrera:
                        'Ingeniería en Agricultura Sustentable y Protegida',
                  ),
                  SizedBox(height: 10.0),
                  CardInfoAlumno(
                    nombreA: 'Jesus Alejandro Orozco Medina',
                    matricula: '202200412',
                    promedio: 0,
                    carrera:
                        'Ingeniería en Agricultura Sustentable y Protegida',
                  ),
                  SizedBox(height: 10.0),
                  CardInfoAlumno(
                    nombreA: 'Jaruny Guadalupe Cardenas Tirado',
                    matricula: '202200412',
                    promedio: 0,
                    carrera: 'Ingeniería en Mantenimiento Industrial',
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
            MaterialPageRoute(builder: (context) => RegistroAlumno()),
          );
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add_circle, color: Colors.white),
        tooltip: 'Agregar nuevo docente',
        elevation: 5,
      ),
      // Boton flotante
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
