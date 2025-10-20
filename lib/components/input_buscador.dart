import 'package:flutter/material.dart';

class InputBuscador extends StatelessWidget {
  final Function(String)? onChanged;

  const InputBuscador({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      borderRadius: BorderRadius.circular(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Buscar...',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[700],
            ),
            hintStyle: TextStyle(color: Colors.grey[600]),
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.white, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.teal, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}
