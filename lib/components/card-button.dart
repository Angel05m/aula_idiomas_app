import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {

  final String titulo;
  final int valor;
  final IconData icono;
  final Color ? iconBackground;


  const CardButton({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
    this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            width: 150,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar e icono
                  SizedBox(height: 30),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: iconBackground ?? Colors.teal[300],
                    child: Icon(icono, color: Colors.white, size: 30),
                  ),
                  SizedBox(width: 10),
                  // Informacion de la carta
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          valor.toString(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
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
