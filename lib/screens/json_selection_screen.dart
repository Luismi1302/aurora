import 'package:flutter/material.dart';
import 'convenios_descentralizados_screen.dart';
import 'convenios_cem_screen.dart';
import 'convenios_sau_screen.dart';
import 'convenios_sar_screen.dart';
import 'convenios_hrt_screen.dart';
import 'convenios_cai_screen.dart';
import 'semaforizacion_screen.dart';

class JsonSelectionScreen extends StatelessWidget {
  const JsonSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualización de Convenios'),
        backgroundColor: const Color(0xFF7D5492),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildConvenioCard(
            context,
            'Convenios Descentralizados',
            'Ver información de convenios descentralizados',
            Icons.assignment,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConveniosDescentralizadosScreen()),
            ),
          ),
          _buildConvenioCard(
            context,
            'Convenios CEM',
            'Ver información de convenios CEM',
            Icons.business,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConveniosCemScreen()),
            ),
          ),
          _buildConvenioCard(
            context,
            'Convenios SAU',
            'Ver información de convenios SAU',
            Icons.local_hospital,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConveniosSauScreen()),
            ),
          ),
          _buildConvenioCard(
            context,
            'Convenios SAR',
            'Ver información de convenios SAR',
            Icons.healing,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConveniosSarScreen()),
            ),
          ),
          _buildConvenioCard(
            context,
            'Convenios HRT',
            'Ver información de convenios HRT',
            Icons.home_work,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConveniosHrtScreen()),
            ),
          ),
          _buildConvenioCard(
            context,
            'Convenios CAI',
            'Ver información de convenios CAI',
            Icons.child_care,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConveniosCaiScreen()),
            ),
          ),
          _buildConvenioCard(
            context,
            'Semaforización',
            'Ver información de semaforización',
            Icons.traffic,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SemaforizacionScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConvenioCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(icon, size: 40.0, color: const Color(0xFF7D5492)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
