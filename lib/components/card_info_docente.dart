import 'package:aula_idiomas_app/controllers/DocenteController.dart';
import 'package:aula_idiomas_app/controllers/ListaDocenteController.dart';
import 'package:aula_idiomas_app/screens/coordinacion/editar_docente.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardInfoDocente extends StatelessWidget {
  final int idDocente; 
  final String nombre;
  final String correo;
  final bool isActive; 

  const CardInfoDocente({
    super.key,
    required this.idDocente,
    required this.nombre,
    required this.correo,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final listaDocenteController = Get.find<ListaDocenteController>();
    final docentecontroller = Get.find<DocenteController>();

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.all(12.0),
        child: Row(
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
                    nombre,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    correo,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón Editar
                SizedBox(
                  width: 40,
                  height: 35,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.edit, color: Colors.teal, size: 25),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarDocente(idDocente: idDocente),
                        ),
                      );

                      if (result == true) {
                        listaDocenteController.refreshDocentes();
                      }
                    },
                  ),
                ),

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
                        docentecontroller.deshabilitarDocente(idDocente, context);
                      } else {
                        docentecontroller.habilitarDocente(idDocente, context);
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
