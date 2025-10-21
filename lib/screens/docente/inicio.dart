import 'package:aula_idiomas_app/components/card-button.dart';
import 'package:flutter/material.dart';

class InicioDocente extends StatefulWidget {
  const InicioDocente({super.key});

  @override
  State<InicioDocente> createState() => _InicioDocenteState();
}

class _InicioDocenteState extends State<InicioDocente> {
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
                      titulo: 'Actividades',
                      valor: 2,
                      icono: Icons.local_activity,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'Actividades Pendientes',
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
                      titulo: 'Actividades',
                      valor: 2,
                      icono: Icons.local_activity,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CardButton(
                      titulo: 'Actividades Pendientes',
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
