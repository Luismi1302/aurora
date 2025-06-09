import 'dart:convert';
import 'package:flutter/services.dart';
import 'mongodb_service.dart';

class MigrationService {
  final MongoDBService _mongoService = MongoDBService();

  Future<void> migrateData() async {
    try {
      await _mongoService.connect();
      
      // Migrar datos de semaforización
      await _migrateCollection(
        'assets/Convenios.Semaforizacion.json',
        'semaforizacion'
      );

      // Migrar datos de convenios descentralizados
      await _migrateCollection(
        'assets/Convenios.Convenios_Descentralizados.json',
        'convenios_descentralizados'
      );

      // Migrar datos de CEM
      await _migrateCollection(
        'assets/Convenios.Convenios_CEM.json',
        'convenios_cem'
      );

      // Migrar datos de SAU
      await _migrateCollection(
        'assets/Convenios.Convenio_SAU.json',
        'convenios_sau'
      );

      // Migrar datos de SAR
      await _migrateCollection(
        'assets/Convenios.Convenio_SAR.json',
        'convenios_sar'
      );

      // Migrar datos de HRT
      await _migrateCollection(
        'assets/Convenios.Convenio_HRT.json',
        'convenios_hrt'
      );

      // Migrar datos de CAI
      await _migrateCollection(
        'assets/Convenios.Convenio_CAI.json',
        'convenios_cai'
      );

      print('Migración completada exitosamente');
    } catch (e) {
      print('Error durante la migración: $e');
      rethrow;
    } finally {
      await _mongoService.disconnect();
    }
  }

  Future<void> _migrateCollection(String jsonPath, String collectionName) async {
    try {
      print('Migrando datos de $jsonPath a la colección $collectionName...');
      
      // Leer el archivo JSON
      final String jsonString = await rootBundle.loadString(jsonPath);
      final List<dynamic> jsonData = json.decode(jsonString);

      // Eliminar documentos existentes en la colección
      await _mongoService.deleteDocument(collectionName, {});

      // Insertar los nuevos documentos
      for (var item in jsonData) {
        await _mongoService.insertDocument(collectionName, item as Map<String, dynamic>);
      }

      print('Migración completada para $collectionName: ${jsonData.length} documentos');
    } catch (e) {
      print('Error migrando $jsonPath: $e');
      rethrow;
    }
  }
} 