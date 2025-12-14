import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mem_friend/app/core/config/config_helper.dart';
import 'package:mem_friend/app/data/providers/database_helper.dart';
import 'package:path_provider/path_provider.dart';

class ViFaceCore {
  static const MethodChannel _m = MethodChannel('vi_face_core/methods');
  static late Future<bool> loadAIModelFuture;

  static initialize() async {
    loadAIModelFuture = loadAIModel(detectGpu: false, recognitionGpu: false);
    loadDatabase();
  }

  static Future<bool> loadAIModel({
    required bool detectGpu,
    required bool recognitionGpu,
  }) async {
    final res = await _m.invokeMethod<bool>('loadAIModel', {
      'detect_gpu': detectGpu,
      'recognition_gpu': recognitionGpu,
    });
    return res ?? false;
  }

  static Future<bool> loadDatabase() async {
    final filePath = ConfigHelper.aiVectorDatabasePath;
    if (filePath?.isEmpty != false) {
      return false;
    }
    final res = await _m.invokeMethod('loadDatabase', {'filePath': filePath});
    return res ?? false;
  }

  static Future<List<double>?> faceToVector(
    List<int> bitmap,
    int width,
    int height,
  ) {
    return _m.invokeMethod('faceToVector', {
      'bitmap': bitmap,
      'width': width,
      'height': height,
    });
  }

  static Future<Map<Object?, Object?>?> faceRecognition(
    List<int> bitmap,
    int width,
    int height,
  ) {
    return _m.invokeMethod('faceRecognition', {
      'bitmap': bitmap,
      'width': width,
      'height': height,
    });
  }

  /// Get all faces from database and return formatted data for buildVectorData
  static Future<Map<String, dynamic>> getAllFacesData() async {
    final databaseHelper = DatabaseHelper();
    final faces = await databaseHelper.getAllFaces();

    final faceIds = <int>[];
    final faceVectors = <List<double>>[];

    for (final face in faces) {
      if (face.id != null) {
        faceIds.add(face.id!);
        final vector = face.vector;
        faceVectors.add(vector);
      }
    }

    return {'faceIds': faceIds, 'faceVectors': faceVectors};
  }

  static Future<String> buildVectorData() async {
    final databaseHelper = DatabaseHelper();
    final faces = await databaseHelper.getAllFaces();

    final faceIds = <int>[];
    final faceVectors = <List<double>>[];

    for (final face in faces) {
      if (face.id != null) {
        faceIds.add(face.id!);
        final vector = face.vector;
        faceVectors.add(vector);
      }
    }

    final folderSaveTree =
        '${(await getApplicationDocumentsDirectory()).path}/ai_vectors';
    final filePath =
        await _m.invokeMethod<String>('buildVectorData', {
          'faceIds': faceIds,
          'faceVectors': faceVectors,
          'folderSaveTree': folderSaveTree,
        }) ??
        '';

    ConfigHelper.setAiVectorDatabasePath(filePath);
    loadDatabase();
    return filePath;
  }

  static Future<bool?> faceRecognitionConfig({
    required int minDistanceFace,
    required int maxDistanceFace,
    required int maxAngleFace,
    required double faceRecognitionThreshold,
    required bool resizeOption,
    required int rotateValue,
  }) {
    return _m.invokeMethod('faceRecognitionConfig', {
      'minDistanceFace': minDistanceFace,
      'maxDistanceFace': maxDistanceFace,
      'maxAngleFace': maxAngleFace,
      'faceRecognitionThreshold': faceRecognitionThreshold,
      'resize_option': resizeOption,
      'rotateValue': rotateValue,
    });
  }
}
