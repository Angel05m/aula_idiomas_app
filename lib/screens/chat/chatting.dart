import 'dart:async';
import 'package:aula_idiomas_app/controllers/ChatController.dart';
import 'package:flutter/material.dart';
import 'package:aula_idiomas_app/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chatting extends StatefulWidget {
  final Usuario receptor;

  const Chatting({super.key, required this.receptor});

  @override
  State<Chatting> createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<dynamic> mensajes = [];
  String myId = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    myId = prefs.getInt("userId")?.toString() ?? "";

    await cargarMensajes();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      cargarMensajes();
    });
  }

  void scrollAbajo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> cargarMensajes() async {
    final data = await ChatController.obtenerMensajes(widget.receptor.id!);

    setState(() {
      mensajes = data;
      mensajes.sort((a, b) =>
          a["created_at"].toString().compareTo(b["created_at"].toString()));
    });

    scrollAbajo();
  }

  Future<void> enviar() async {
    final texto = _messageController.text.trim();
    if (texto.isEmpty) return;

    _messageController.clear();

    setState(() {
      mensajes.add({
        "mensaje": texto,
        "de_usuario": myId,
        "para_usuario": widget.receptor.id.toString(),
      });
    });

    scrollAbajo();

    final ok = await ChatController.enviarMensaje(
      paraUsuario: widget.receptor.id!,
      mensaje: texto,
    );

    if (ok) {
      cargarMensajes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo enviar el mensaje")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "${widget.receptor.nombres} ${widget.receptor.apPaterno}",
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: mensajes.isEmpty
                ? const Center(
                    child: Text(
                      "No hay mensajes aún",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: mensajes.length,
                    itemBuilder: (_, index) {
                      final m = mensajes[index];
                      final soyYo = m["de_usuario"].toString() == myId;

                      return _Message(
                        m["mensaje"].toString(),
                        soyYo,
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    onPressed: enviar,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _Message(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.teal.shade700 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isMe ? Colors.white : Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
