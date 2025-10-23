import 'package:aula_idiomas_app/components/card_actividad_docente.dart';
import 'package:aula_idiomas_app/screens/docente/registrar_actividad.dart';
import 'package:flutter/material.dart';

class ActividadesDocente extends StatefulWidget {
  const ActividadesDocente({super.key});

  @override
  State<ActividadesDocente> createState() => _ActividadesDocenteState();
}

class _ActividadesDocenteState extends State<ActividadesDocente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text(
              'Actividades',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text('Añade, edita y gestiona las actividades'),
            const SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar actividad...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              onSubmitted: (value) {
                // listaDocenteController.searchDocentes(value.trim());
              },
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                CardActividadDocente(
                  tituloActividad: 'Past Simple vs Past Continuos',
                  codigo: 'COD-001',
                  fecha: '20/10/2025',
                  tipo: 'Pregunta de Opcion multiple',
                  descripcion: 'Este es u ejemplo de descripción de una actividad creada',
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CrearActividadDocente(),
            ),
          );

          if (result == true) {
            // await listaDocenteController.refreshDocentes();
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.assignment_add, color: Colors.white),
        tooltip: 'Crear nueva actividad',
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
