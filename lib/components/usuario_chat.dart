import 'package:aula_idiomas_app/screens/chat/chatting.dart';
import 'package:flutter/material.dart';


class UsuarioChat extends StatelessWidget {
    final String nombreM;
  final String tipoUsuario;

  const UsuarioChat({super.key, required this.nombreM, required this.tipoUsuario});

  @override
  Widget build(BuildContext context) {
     return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
        elevation: WidgetStateProperty.all(3.0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        ),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Chatting() ));
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombreM,
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      tipoUsuario,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w100,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}