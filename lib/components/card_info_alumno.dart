import 'package:aula_idiomas_app/screens/coordinacion/editar_alumno.dart';
import 'package:flutter/material.dart';

class CardInfoAlumno extends StatelessWidget {
  final String nombreA;
  final String matricula;
  final double promedio;
  final String carrera;

  const CardInfoAlumno({
    super.key,
    required this.nombreA,
    required this.matricula,
    required this.promedio,
    required this.carrera,
  });

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(Icons.edit, color: Colors.teal, size: 25),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditarAlumno()),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 35,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                    onPressed: () {},
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
