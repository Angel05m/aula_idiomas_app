import 'package:aula_idiomas_app/screens/coordinacion/editar_grupo.dart';
import 'package:flutter/material.dart';

class CardInfoGrupo extends StatelessWidget {
  final String grupo;
  final String cuatri;
  final String anio;
  final String carrera;

  const CardInfoGrupo({
    super.key,
    required this.grupo,
    required this.cuatri,
    required this.anio,
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
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grupo,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        cuatri,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.teal[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Text(
                        anio,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.teal[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    carrera,
                    style: TextStyle(
                      fontSize: 13.0,
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
                        MaterialPageRoute(builder: (context) => EditarGrupo()),
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
