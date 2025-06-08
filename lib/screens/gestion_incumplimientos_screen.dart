import 'package:flutter/material.dart';

class GestionIncumplomientosScreen extends StatelessWidget {
  final List<String> categorias = const [
    "CEM DESCENTRALIZADOS",
    "CEM",
    "CAI",
    "SAU",
    "SAR",
    "HRT"
  ];

  // Ejemplo de datos para la tabla
  final List<Map<String, dynamic>> reportes = const [
    {
      'nombre': 'Reporte 1',
      'fecha': '2024-06-01',
      'estado': true,
    },
    {
      'nombre': 'Reporte 2',
      'fecha': null,
      'estado': false,
    },
    {
      'nombre': 'Reporte 3',
      'fecha': '2024-06-03',
      'estado': null,
    },
  ];

  const GestionIncumplomientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Botones de categorías en la parte superior
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categorias.map((cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción al presionar el botón (puedes agregar lógica de filtrado aquí)
                    },
                    child: Text(cat, style: const TextStyle(fontSize: 12)),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Region')),
                DataColumn(label: Text('Distrito')),
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Estado')),
                DataColumn(label: Text('Notificación')),
              ],
              rows: reportes.map((reporte) {
                bool notificacion = reporte['fecha'] == null || reporte['estado'] == null || reporte['estado'] == false;
                return DataRow(
                  cells: [
                    DataCell(Text(reporte['nombre'] ?? '')),
                    DataCell(Text(reporte['fecha'] ?? 'Sin fecha')),
                    DataCell(Text(
                      reporte['estado'] == null
                          ? 'Sin estado'
                          : (reporte['estado'] ? 'Cumplido' : 'Incumplido'),
                      style: TextStyle(
                        color: reporte['estado'] == false ? Colors.red : null,
                      ),
                    )),
                    DataCell(
                      notificacion
                          ? Row(
                              children: [
                                Icon(Icons.warning, color: Colors.orange, size: 20),
                                SizedBox(width: 4),
                                Text('Revisar', style: TextStyle(color: Colors.orange)),
                              ],
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
