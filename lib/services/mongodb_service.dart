import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  static final MongoDBService _instance = MongoDBService._internal();
  late Db _db;
  bool _isConnected = false;

  factory MongoDBService() {
    return _instance;
  }

  MongoDBService._internal();

  Future<void> connect() async {
    if (!_isConnected) {
      try {
        _db = await Db.create('mongodb+srv://dariksodanielo:salchipapa123@ministeriomujer.hsbgzs1.mongodb.net/');
        await _db.open();
        _isConnected = true;
        print('Conexión exitosa a MongoDB');
      } catch (e) {
        print('Error conectando a MongoDB: $e');
        rethrow;
      }
    }
  }

  Future<void> disconnect() async {
    if (_isConnected) {
      await _db.close();
      _isConnected = false;
      print('Desconexión exitosa de MongoDB');
    }
  }

  Future<List<Map<String, dynamic>>> getCollection(String collectionName) async {
    if (!_isConnected) await connect();
    try {
      final collection = _db.collection(collectionName);
      final cursor = collection.find();
      return await cursor.toList();
    } catch (e) {
      print('Error obteniendo datos de $collectionName: $e');
      rethrow;
    }
  }

  Future<void> insertDocument(String collectionName, Map<String, dynamic> document) async {
    if (!_isConnected) await connect();
    try {
      final collection = _db.collection(collectionName);
      await collection.insert(document);
    } catch (e) {
      print('Error insertando documento en $collectionName: $e');
      rethrow;
    }
  }

  Future<void> updateDocument(String collectionName, Map<String, dynamic> query, Map<String, dynamic> update) async {
    if (!_isConnected) await connect();
    try {
      final collection = _db.collection(collectionName);
      await collection.update(query, update);
    } catch (e) {
      print('Error actualizando documento en $collectionName: $e');
      rethrow;
    }
  }

  Future<void> deleteDocument(String collectionName, Map<String, dynamic> query) async {
    if (!_isConnected) await connect();
    try {
      final collection = _db.collection(collectionName);
      await collection.remove(query);
    } catch (e) {
      print('Error eliminando documento en $collectionName: $e');
      rethrow;
    }
  }
} 