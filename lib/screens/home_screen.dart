import 'package:flutter/material.dart';
import 'convenios_screen.dart';
import 'semaforizacion_screen.dart';
import 'diagnostico_screen.dart';
import 'diagnostico/panel_diagnostico_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('AURORA'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuButton(
                context,
                'Convenios',
                Icons.assignment,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConveniosScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                'Seguimiento',
                Icons.track_changes,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SemaforizacionScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                'Diagnóstico',
                Icons.analytics,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiagnosticoScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                'Panel',
                Icons.dashboard,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PanelDiagnosticoScreen(),
                    ),
                  );
                },
              ),
              ],
        ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
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
            Theme.of(context).primaryColor,
            Colors.red[400]!,
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
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
