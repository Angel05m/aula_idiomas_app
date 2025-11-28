import 'package:aula_idiomas_app/components/card_chat.dart';
import 'package:aula_idiomas_app/components/input_buscador.dart';
import 'package:aula_idiomas_app/controllers/ChatController.dart';
import 'package:aula_idiomas_app/models/usuario.dart';
import 'package:aula_idiomas_app/screens/chat/lista_chat.dart';
import 'package:flutter/material.dart';

class InicioChat extends StatefulWidget {
  const InicioChat({super.key});

  @override
  State<InicioChat> createState() => _InicioChatState();
}

class _InicioChatState extends State<InicioChat> {
  List<Usuario> contactos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarContactos();
  }

  Future<void> cargarContactos() async {
    final data = await ChatController.obtenerHistorial();

    setState(() {
      contactos = data["contactos"]!;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mensajería',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.teal.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
        titleSpacing: 5.0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: contactos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (_, i) {
                        final u = contactos[i];

                        return CardChat(
                          usuario: u,
                          mensaje: "Ver mensajes...",
                          hora: "",
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await ChatController.obtenerHistorial();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListaChat(usuarios: data["usuarios"]!),
            ),
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
