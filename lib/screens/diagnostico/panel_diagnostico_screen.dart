import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/dashboard_service.dart';

class PanelDiagnosticoScreen extends StatefulWidget {
  const PanelDiagnosticoScreen({Key? key}) : super(key: key);

  @override
  State<PanelDiagnosticoScreen> createState() => _PanelDiagnosticoScreenState();
}

class _PanelDiagnosticoScreenState extends State<PanelDiagnosticoScreen> {
  final DashboardService _dashboardService = DashboardService();
  Map<String, dynamic> _allData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _dashboardService.loadAllData();
    setState(() {
      _allData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_allData.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final conveniosPorTipo = _dashboardService.getConveniosPorTipo(_allData);
    final conveniosPorRegion = _dashboardService.getConveniosPorRegion(_allData);
    final estadoConvenios = _dashboardService.getEstadoConvenios(_allData);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel'),
        // Usa el color del theme global
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tarjetas resumen agrupadas
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: conveniosPorTipo.entries.map((entry) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Card(
                      // Usa el color del theme global
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              entry.value.toString(),
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Gráfico de torta por tipo
            _buildChartCard(
              title: 'Distribución por Tipo',
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                  sections: _buildPieSections(conveniosPorTipo, context),
                ),
              ),
            ),
            // Gráfico de barras apiladas por región (solo top 8)
            _buildChartCard(
              title: 'Top 8 Regiones con más convenios',
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (conveniosPorRegion.values.isEmpty
                          ? 1
                          : conveniosPorRegion.values.reduce((a, b) => a > b ? a : b))
                      .toDouble() +
                      1,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Theme.of(context).primaryColor,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final region = conveniosPorRegion.keys.toList()[group.x.toInt()];
                        return BarTooltipItem(
                          '$region\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: rod.toY.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          final keys = conveniosPorRegion.keys.toList();
                          if (idx >= 0 && idx < 8 && idx < keys.length) {
                            return RotatedBox(
                              quarterTurns: 1,
                              child: Text(
                                keys[idx],
                                style: TextStyle(fontSize: 10, color: Theme.of(context).primaryColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: conveniosPorRegion.entries
                      .toList()
                      .asMap()
                      .entries
                      .where((entry) => entry.key < 8)
                      .map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value.toDouble(),
                          color: Theme.of(context).primaryColor,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            // Gráfico de barras por estado
            _buildChartCard(
              title: 'Convenios por Estado',
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (estadoConvenios.values.isEmpty
                          ? 1
                          : estadoConvenios.values.reduce((a, b) => a > b ? a : b))
                      .toDouble() +
                      1,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Theme.of(context).primaryColor,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final estado = estadoConvenios.keys.toList()[group.x.toInt()];
                        return BarTooltipItem(
                          '$estado\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: rod.toY.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          final keys = estadoConvenios.keys.toList();
                          if (idx >= 0 && idx < keys.length) {
                            return RotatedBox(
                              quarterTurns: 1,
                              child: Text(
                                keys[idx],
                                style: TextStyle(fontSize: 10, color: Theme.of(context).primaryColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: estadoConvenios.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value.toDouble(),
                          color: Theme.of(context).colorScheme.secondary,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 220,
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(Map<String, int> data, BuildContext context) {
    final colors = [
      Theme.of(context).primaryColor,
      Theme.of(context).colorScheme.secondary,
      Colors.red[200]!,
      Colors.red[400]!,
      Colors.red[900]!,
    ];
    final total = data.values.fold<int>(0, (a, b) => a + b);
    return data.entries.toList().asMap().entries.map((entry) {
      final value = entry.value;
      final percent = total == 0 ? 0 : value.value / total * 100;
      return PieChartSectionData(
        color: colors[entry.key % colors.length],
        value: value.value.toDouble(),
        title: '${value.key}\n${percent.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }).toList();
  }
}
