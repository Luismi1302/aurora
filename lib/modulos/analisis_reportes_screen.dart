import 'package:flutter/material.dart';

class AnalisisReportesScreen extends StatefulWidget {
  const AnalisisReportesScreen({super.key});

  @override
  State<AnalisisReportesScreen> createState() => _AnalisisReportesScreenState();
}

class _AnalisisReportesScreenState extends State<AnalisisReportesScreen> with SingleTickerProviderStateMixin {
  String? filtroEstado;
  String? filtroRegion;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Análisis y Reportes'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Reportes'),
              // Si necesitas más pestañas, agrégalas aquí
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReportesTab(context),
            // Si agregas más pestañas, agrégalas aquí
          ],
        ),
      ),
    );
  }

  Widget _buildReportesTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filtrar por:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildFiltroButton(
                context,
                label: filtroEstado ?? 'Estado',
                onPressed: () async {
                  final seleccionado = await _mostrarDialogoFiltro(context, 'Estado', ['Activo', 'Inactivo', 'Pendiente']);
                  if (seleccionado != null) setState(() => filtroEstado = seleccionado);
                },
              ),
              const SizedBox(width: 8),
              _buildFiltroButton(
                context,
                label: filtroRegion ?? 'Región',
                onPressed: () async {
                  final seleccionado = await _mostrarDialogoFiltro(context, 'Región', ['Norte', 'Sur', 'Este', 'Oeste']);
                  if (seleccionado != null) setState(() => filtroRegion = seleccionado);
                },
              ),
              // Agrega más botones de filtro aquí si es necesario
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Text(
                'Aquí irán los reportes filtrados por:\n'
                'Estado: ${filtroEstado ?? "-"}\n'
                'Región: ${filtroRegion ?? "-"}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroButton(BuildContext context, {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Future<String?> _mostrarDialogoFiltro(BuildContext context, String titulo, List<String> opciones) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Selecciona $titulo'),
          children: opciones
              .map((opcion) => SimpleDialogOption(
                    child: Text(opcion),
                    onPressed: () => Navigator.pop(context, opcion),
                  ))
              .toList(),
        );
      },
    );
  }
}
