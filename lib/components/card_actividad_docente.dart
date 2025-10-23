import 'package:aula_idiomas_app/screens/docente/aignar_actividad.dart';
import 'package:flutter/material.dart';

class CardActividadDocente extends StatelessWidget {
  final String tituloActividad;
  final String codigo;
  final String fecha;
  final String tipo;
  final String descripcion;

  const CardActividadDocente({
    super.key,
    required this.tituloActividad,
    required this.codigo,
    required this.fecha,
    required this.tipo,
    required this.descripcion,
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
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tituloActividad,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Codigo:',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              flex: 2,
                              child: Text(
                                codigo,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Fecha:',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                fecha,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Tipo:',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          tipo,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.0),
                  Text(
                    'Descripcion:',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    descripcion,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  TextButton(
                    style: ButtonStyle(),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AsignarActividadDocente(),
                      //   ),
                      // );
                    },
                    child: Icon(Icons.add_circle, size: 20),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.edit, color: Colors.teal, size: 20),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.delete,
                      color: Colors.orange.shade300,
                      size: 20,
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
