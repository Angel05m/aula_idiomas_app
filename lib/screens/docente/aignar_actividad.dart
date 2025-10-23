import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class AsignarActividadDocente extends StatefulWidget {
  const AsignarActividadDocente({super.key});

  @override
  State<AsignarActividadDocente> createState() =>
      _AsignarActividadDocenteState();
}

class _AsignarActividadDocenteState extends State<AsignarActividadDocente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Asignar Actividad',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Text('Configuracion de actividad'),
                  TextField(
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      labelText: 'Tiempo de la actividad',
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintText: 'Ej: Respuesta A',
                      hintStyle: TextStyle(fontSize: 14.0),
                      floatingLabelStyle: TextStyle(color: Colors.teal),
                      contentPadding: EdgeInsets.all(7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  Text('Fecha de entrega:'),
                  TextField(
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      labelText: 'Tiempo de la actividad',
                      labelStyle: TextStyle(fontSize: 14.0),
                      hintText: 'Ej: Respuesta A',
                      hintStyle: TextStyle(fontSize: 14.0),
                      floatingLabelStyle: TextStyle(color: Colors.teal),
                      contentPadding: EdgeInsets.all(7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.teal, width: 3.0),
                      ),
                    ),
                  ),
                  DateTimeFormField(firstDate: DateTime(2000), lastDate: DateTime(2100),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
