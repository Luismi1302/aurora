import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<List<dynamic>> loadJsonData(String assetPath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = assetPath.split('/').last;
      final file = File('${directory.path}/$fileName');
      
      if (await file.exists()) {
        final String jsonString = await file.readAsString();
        return jsonDecode(jsonString);
      } else {
        final String jsonString = await rootBundle.loadString(assetPath);
        return jsonDecode(jsonString);
      }
    } catch (e) {
      print('Error loading JSON: $e');
      rethrow;
    }
  }

  Future<void> saveJsonData(String assetPath, List<dynamic> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = assetPath.split('/').last;
      final file = File('${directory.path}/$fileName');
      
      final String jsonString = jsonEncode(data);
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving JSON: $e');
      rethrow;
    }
  }
}
