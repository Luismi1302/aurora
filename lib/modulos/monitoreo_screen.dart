import 'package:flutter/material.dart';

class MonitoreoScreen extends StatelessWidget {
  const MonitoreoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7D5492),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text('Monitoreo y Seguimiento'),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Contenido de Monitoreo',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

