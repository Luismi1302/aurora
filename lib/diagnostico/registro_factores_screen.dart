import 'package:flutter/material.dart';

class RegistroFactoresScreen extends StatelessWidget {
  const RegistroFactoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Factores'),
        backgroundColor: const Color(0xFF7D5492),
      ),
      body: const Center(
        child: Text('Registro de Factores'),
      ),
    );
  }
}
