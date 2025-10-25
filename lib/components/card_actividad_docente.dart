import 'package:aula_idiomas_app/screens/docente/aignar_actividad.dart';
import 'package:flutter/material.dart';

class CardActividadDocente extends StatelessWidget {
  final int pk_actividad;
  final String tituloActividad;
  final String codigo;
  final String fecha;
  final String tipo;
  final String descripcion;
  final bool isActive;
  final VoidCallback? onToggleActive;

  const CardActividadDocente({
    required this.pk_actividad,
    super.key,
    required this.tituloActividad,
    required this.codigo,
    required this.fecha,
    required this.tipo,
    required this.descripcion,
    required this.isActive,
    this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tituloActividad,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Codigo:',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              codigo,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Fecha:',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              fecha,
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w300,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      const Text(
                        'Tipo:',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        tipo,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    'Descripcion:',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    descripcion,
                    style: const TextStyle(
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AsignarActividadDocente(
                            pk_actividad: pk_actividad.toString(), 
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.add_circle, size: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      // Lógica de editar actividad
                    },
                    child: const Icon(Icons.edit, color: Colors.teal, size: 20),
                  ),
                  TextButton(
                    onPressed: onToggleActive,
                    child: Icon(
                      isActive ? Icons.block : Icons.check_circle,
                      color: isActive ? Colors.orange.shade300 : Colors.teal,
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
