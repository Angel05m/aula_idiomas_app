import 'package:aula_idiomas_app/components/usuario_chat.dart';
import 'package:flutter/material.dart';

class ListaChat extends StatefulWidget {
  const ListaChat({super.key});

  @override
  State<ListaChat> createState() => _ListaChatState();
}

class _ListaChatState extends State<ListaChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo mensaje',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.teal.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        // VISUALIZACION DEL CHAT
        child: ListView(
          // LISTADO DE LOS CHAT
          children: [
            for (int i = 1; i < 10; i++) ...[
              UsuarioChat(
                nombreM: 'Jaruny Cardenas Tirado',
                tipoUsuario: 'Docente',
              ),
              SizedBox(height: 8.0),
            ],
          ],
        ),
      ),
    );
  }
}
