import 'package:flutter/material.dart';

class Chatting extends StatefulWidget {
  const Chatting({super.key});

  @override
  State<Chatting> createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Angel Ariel Salazar Medina',
          style: TextStyle(
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
          // LISTA DE MENSAJE
          Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.all(10.0),
              children: [
                _Message('Hola, profesor, ¿tiene un momento?', true),
                _Message('Claro, dime, ¿En qué puedo ayudarte?', false),
                _Message(
                  'Quería pedirle información sobre el proyecto final de la materia.',
                  true,
                ),
                _Message(
                  'Perfecto. ¿Qué aspecto del proyecto necesitas aclarar: la temática, el formato o la fecha de entrega?',
                  false,
                ),
                _Message(
                  'Principalmente sobre la fecha de entrega. No estoy seguro si es la próxima semana o la siguiente.',
                  true,
                ),
                _Message(
                  'La entrega es el viernes de la próxima semana. Te recomiendo empezar cuanto antes para revisar dudas conmigo antes de la entrega.',
                  false,
                ),
              ],
            ),
          ),

          // APARTADO PARA ENVIAR MENSAJE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    onPressed: () {},
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

  // MENSAJE TRUE = ENVIADO, FLASE = RECIBIDO
  Widget _Message(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        // MARGIN Y PADDING DEL MENSAJE
        constraints: BoxConstraints(
          maxWidth:MediaQuery.of(context).size.width *0.8, //ESPACIADO
        ),
        margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 12),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          // BORDER Y COLOR
          color: isMe ? Colors.teal.shade700 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe
                ? const Radius.circular(12)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // TEXTO DEL MENSAJE
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
