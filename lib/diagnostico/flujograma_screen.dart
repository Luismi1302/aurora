import 'package:flutter/material.dart';

class FlujogramaScreen extends StatelessWidget {
  const FlujogramaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flujograma'),
        backgroundColor: const Color(0xFF7D5492),
      ),
      body: const Center(
        child: Text('Flujograma'),
      ),
    );
  }
}
