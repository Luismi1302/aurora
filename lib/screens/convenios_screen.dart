import 'package:flutter/material.dart';
import 'convenios_cem_screen.dart';
import 'convenios_descentralizados_screen.dart';
import 'convenios_hrt_screen.dart';
import 'convenios_sar_screen.dart';
import 'convenios_sau_screen.dart';
import 'convenios_cai_screen.dart';

class ConveniosScreen extends StatelessWidget {
  const ConveniosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final convenios = [
      {
        'name': 'DESCENTRALIZADOS',
        'icon': Icons.location_city,
        'screen': const ConveniosDescentralizadosScreen(),
      },
      {
        'name': 'CEM',
        'icon': Icons.business,
        'screen': const ConveniosCemScreen(),
      },
      {
        'name': 'SAU',
        'icon': Icons.support_agent,
        'screen': const ConveniosSauScreen(),
      },
      {
        'name': 'SAR',
        'icon': Icons.room_service,
        'screen': const ConveniosSarScreen(),
      },
      {
        'name': 'HRT',
        'icon': Icons.local_hospital,
        'screen': const ConveniosHrtScreen(),
      },
      {
        'name': 'CAI',
        'icon': Icons.home_work,
        'screen': const ConveniosCaiScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convenios'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[50]!, Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: convenios.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => convenios[index]['screen'] as Widget,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          convenios[index]['icon'] as IconData,
                          color: Theme.of(context).primaryColor,
                          size: 30,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          convenios[index]['name'] as String,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
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
