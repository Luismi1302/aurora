import 'package:flutter/material.dart';
import 'diagnostico/panel_diagnostico_screen.dart';
import 'diagnostico/matriz_compromisos_screen.dart';
import 'diagnostico/registro_factores_screen.dart';

class DiagnosticoScreen extends StatelessWidget {
  const DiagnosticoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnóstico'),
        backgroundColor: Theme.of(context).primaryColor, // Cambiado a rojo del tema
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[50]!, Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildDiagnosticButton(
              context,
              'Panel de Diagnóstico',
              Icons.dashboard,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PanelDiagnosticoScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildDiagnosticButton(
              context,
              'Matriz de Compromisos',
              Icons.table_chart,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MatrizCompromisosScreen()),
              ),
            ),
            const SizedBox(height: 20),
            _buildDiagnosticButton(
              context,
              'Registro de Factores',
              Icons.add_chart,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistroFactoresScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,  // Cambiado de morado a rojo
            Colors.red[400]!,  // Cambiado de morado a rojo más claro
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 30),
                const SizedBox(width: 15),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
