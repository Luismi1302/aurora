import 'dart:convert';
import 'package:flutter/services.dart';

class DashboardService {
  Future<Map<String, dynamic>> loadAllData() async {
    try {
      final semaforizacion = await rootBundle.loadString('assets/Convenios.Semaforizacion.json');
      final descentralizados = await rootBundle.loadString('assets/Convenios.Convenios_Descentralizados.json');
      final cem = await rootBundle.loadString('assets/Convenios.Convenios_CEM.json');
      final sau = await rootBundle.loadString('assets/Convenios.Convenio_SAU.json');
      final sar = await rootBundle.loadString('assets/Convenios.Convenio_SAR.json');
      final hrt = await rootBundle.loadString('assets/Convenios.Convenio_HRT.json');
      final cai = await rootBundle.loadString('assets/Convenios.Convenio_CAI.json');

      return {
        'semaforizacion': json.decode(semaforizacion),
        'descentralizados': json.decode(descentralizados),
        'cem': json.decode(cem),
        'sau': json.decode(sau),
        'sar': json.decode(sar),
        'hrt': json.decode(hrt),
        'cai': json.decode(cai),
      };
    } catch (e) {
      print('Error loading data: $e');
      return {};
    }
  }

  Map<String, int> getConveniosPorTipo(Map<String, dynamic> data) {
    return {
      'CEM': data['cem']?.length ?? 0,
      'SAU': data['sau']?.length ?? 0,
      'SAR': data['sar']?.length ?? 0,
      'HRT': data['hrt']?.length ?? 0,
      'CAI': data['cai']?.length ?? 0,
    };
  }

  Map<String, int> getConveniosPorRegion(Map<String, dynamic> data) {
    Map<String, int> regiones = {};
    void processData(List items) {
      for (var item in items) {
        String region = item['REGION'] ?? item['REGIÓN'] ?? 'No especificado';
        regiones[region] = (regiones[region] ?? 0) + 1;
      }
    }
    for (var dataset in data.values) {
      if (dataset is List) {
        processData(dataset);
      }
    }
    return regiones;
  }

  Map<String, int> getEstadoConvenios(Map<String, dynamic> data) {
    Map<String, int> estados = {};
    void processData(List items) {
      for (var item in items) {
        String estado = item['ESTADO'] ?? item['ESTADO SITUACIONAL'] ?? 'No especificado';
        estados[estado] = (estados[estado] ?? 0) + 1;
      }
    }
    for (var dataset in data.values) {
      if (dataset is List) {
        processData(dataset);
      }
    }
    return estados;
  }
}
