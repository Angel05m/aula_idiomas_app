import 'package:aula_idiomas_app/components/card-button.dart';
// import 'package:aula_idiomas_app/screens/coordinacion/lista-docente.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class InicioCoordinacion extends StatefulWidget {
  const InicioCoordinacion({super.key});

  @override
  State<InicioCoordinacion> createState() => _InicioCoordinacionState();
}

class _InicioCoordinacionState extends State<InicioCoordinacion> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    'Bienvenido',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Coordinador/a, Jaruny Lupe Cardenas Tirado',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Center(
              child: SizedBox(
                height: 500,
                child: GridView.count(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                  ), // Elimina padding interno
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 2,
                  childAspectRatio: 1.7,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    CardButton(
                      titulo: 'Docente',
                      valor: 12,
                      icono: Icons.person,
                      iconBackground: Colors.blue,
                    ),
                    CardButton(
                      titulo: 'Grupos',
                      valor: 20,
                      icono: Icons.groups,
                      iconBackground: Colors.green,
                    ),
                    CardButton(
                      titulo: 'Alumnos',
                      valor: 400,
                      icono: Icons.school,
                      iconBackground: Colors.orange,
                    ),
                    CardButton(
                      titulo: 'Accesos',
                      valor: 3,
                      icono: Icons.key,
                      iconBackground: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
