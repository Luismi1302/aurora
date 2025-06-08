import 'package:flutter/material.dart';

class MatrizCompromisosScreen extends StatelessWidget {
  const MatrizCompromisosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matriz de Compromisos'),
        backgroundColor: const Color(0xFF7D5492),
      ),
      body: const Center(
        child: Text('Matriz de Compromisos'),
      ),
    );
  }
}
