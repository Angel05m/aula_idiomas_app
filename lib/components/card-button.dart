import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final String titulo;
  final int valor;
  final IconData icono;
  final Color? iconBackground;
  final VoidCallback? onTap;

  const CardButton({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
    this.iconBackground,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(7.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: iconBackground ?? Colors.teal[300],
                  child: Icon(icono, color: Colors.white, size: 20),
                ),
              ),
              SizedBox(width: 10.0),
              // Informacion de la carta
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '$valor',
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
