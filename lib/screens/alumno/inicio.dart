import 'package:aula_idiomas_app/components/card-button.dart';
import 'package:flutter/material.dart';

class InicioAlumnos extends StatefulWidget {
  const InicioAlumnos({super.key});

  @override
  State<InicioAlumnos> createState() => _InicioAlumnosState();
}

class _InicioAlumnosState extends State<InicioAlumnos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido/a',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Docente, Melissa Sas Perez',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'General',
                      valor: 2,
                      icono: Icons.local_activity,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'Escritura',
                      valor: 3,
                      icono: Icons.time_to_leave,
                      iconBackground: Colors.green
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'Compresión',
                      valor: 10,
                      icono: Icons.local_activity,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'Hablado',
                      valor: 3,
                      icono: Icons.time_to_leave,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}