import 'package:flutter/material.dart';
import 'service_details_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'name': 'CEM DESCENTRALIZADOS',
        'icon': Icons.location_city,
        'jsonFile': 'convenios_cem_descentralizados.json'
      },
      {
        'name': 'CEM',
        'icon': Icons.business,
        'jsonFile': 'convenios_cem.json'
      },
      {
        'name': 'CAI',
        'icon': Icons.home_work,
        'jsonFile': 'convenios_cai.json'
      },
      {
        'name': 'SAU',
        'icon': Icons.support_agent,
        'jsonFile': 'convenios_sau.json'
      },
      {
        'name': 'SAR',
        'icon': Icons.room_service,
        'jsonFile': 'convenios_sar.json'
      },
      {
        'name': 'HRT',
        'icon': Icons.local_hospital,
        'jsonFile': 'convenios_hrt.json'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios Aurora'),
        backgroundColor: const Color(0xFF7D5492),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5DEE4), Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Icon(
                  service['icon'] as IconData,
                  color: const Color(0xFF7D5492),
                  size: 32,
                ),
                title: Text(
                  service['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailsScreen(
                      serviceName: service['name'] as String,
                      jsonFile: service['jsonFile'] as String,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
