import 'package:flutter/material.dart';

class RegistroAlumno extends StatefulWidget {
  const RegistroAlumno({super.key});

  @override
  State<RegistroAlumno> createState() => _RegistroAlumnoState();
}

class _RegistroAlumnoState extends State<RegistroAlumno> {
  String? _selectedOptionG;
  List<String> _optionsG = ['9', '8', '7'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrar Alumno',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombres:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Ej: Jaruny Lupe',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Apellido Paterno:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Ej: Cárdenas',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Apellido Materno:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Ej: Tirado',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Matricula:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Ej: 202200412',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Grupo:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _selectedOptionG,
                    decoration: InputDecoration(
                      hintText: 'Selecciona un Grupo',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    hint: Text('Selecciona Carrera'),
                    onChanged: (String? newValueC) {
                      setState(() {
                        _selectedOptionG = newValueC;
                      });
                    },
                    items: _optionsG.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(value, overflow: TextOverflow.ellipsis),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20.0),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: Size(double.infinity, 50),
                      elevation: 5.0,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Registrar Alumno',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
