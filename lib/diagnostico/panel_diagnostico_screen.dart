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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Diagnóstico'),
        backgroundColor: const Color(0xFF7D5492),
      ),
      body: const Center(
        child: Text('Panel de Diagnóstico'),
      ),
    );
  }
}
