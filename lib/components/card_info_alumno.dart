import 'package:aula_idiomas_app/controllers/AlumnosController.dart';
import 'package:aula_idiomas_app/screens/coordinacion/editar_alumno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardInfoAlumno extends StatelessWidget {
  final int idAlumno; 
  final String nombreA;
  final String matricula;
  final double promedio;
  final String carrera;
  final bool isActive; 

  const CardInfoAlumno({
    super.key,
    required this.idAlumno,
    required this.nombreA,
    required this.matricula,
    required this.promedio,
    required this.carrera,
    required this.isActive,
  });
  

  @override
  Widget build(BuildContext context) {
    final alumnoController = Get.find<AlumnosController>();

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, //acomodo vertical en un Row
          // mainAxisAlignment: MainAxisAlignment.center,
          //acomodo horizontal en un Row
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.teal[300],
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombreA,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        matricula,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.teal[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Container(
                        width: promedio > 0 ? 28 : 50,
                        height: promedio > 0 ? 28 : 28,
                        decoration: BoxDecoration(
                          color: promedio > 0
                              ? (promedio > 8 ? Colors.teal : Colors.orange)
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          promedio > 0 ? promedio.toStringAsFixed(1) : 'S/N',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: promedio > 0 ? 14 : 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    carrera,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 35,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      isActive ? Icons.delete : Icons.arrow_circle_up,
                      color: isActive ? Colors.orange : Colors.green,
                      size: 25,
                    ),
                    onPressed: () {
                      if (isActive) {
                        alumnoController.deshabilitarAlumno(idAlumno, context);
                      } else {
                        alumnoController.habilitarAlumno(idAlumno, context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
