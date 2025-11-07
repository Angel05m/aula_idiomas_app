import 'package:aula_idiomas_app/components/card_chat.dart';
import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/screens/chat/lista_chat.dart';
import 'package:flutter/material.dart';

class InicioChat extends StatefulWidget {
  const InicioChat({super.key});

  @override
  State<InicioChat> createState() => _InicioChatState();
}

class _InicioChatState extends State<InicioChat> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mensajeria',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.teal.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        titleSpacing: 5.0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        // VISUALIZACION DEL CHAT
        child: Column(
          children: [
            InputBuscador(),
            SizedBox(height: 15),
            Expanded(
              child: ListView(
                // LISTADO DE LOS CHAT
                children: [
                  for  (int i = 1; i<10; i++)...[
                  CardChat(
                    nombre: 'Angel Ariel Salazar Medina',
                    mensaje: 'Hola, profesor, ¿Tiene un momento?',
                    hora: '09:00 p.m.',
                  ),
                  SizedBox(height: 6.0,)
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
      // BOTON FLOTANTE
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ListaChat()),
          );
        },
        backgroundColor: Colors.teal.shade600,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Nuevo mensaje',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
