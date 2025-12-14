import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:mem_friend/app/core/ai/vi_face_core.dart';

import '../models/face.dart';
import '../models/person.dart';
import '../providers/database_helper.dart';

/// Face recognition service that integrates with AI functions
class FaceRecognitionService {
  static FaceRecognitionService? _instance;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  FaceRecognitionService._internal();

  factory FaceRecognitionService() {
    _instance ??= FaceRecognitionService._internal();
    return _instance!;
  }

  /// Search for similar face vector in database
  /// This is a placeholder for the actual AI function integration
  /// In the real implementation, this would call the native AI function
  Future<int?> vectorSearch(Float32List queryVector) async {
    try {
      // Simulate AI processing delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Get all faces from database
      final faces = await _databaseHelper.getAllFaces();

      if (faces.isEmpty) {
        return null;
      }

      // Simple similarity calculation (this would be replaced with actual AI function)
      double bestSimilarity = -1;
      int? bestFaceId;

      // for (final face in faces) {
      //   final similarity = _calculateSimilarity(queryVector, face.vector);
      //   if (similarity > bestSimilarity) {
      //     bestSimilarity = similarity;
      //     bestFaceId = face.id;
      //   }
      // }

      // Return face id if similarity is above threshold
      const double threshold = 0.7; // Adjust based on AI model requirements
      if (bestSimilarity > threshold) {
        return bestFaceId;
      }

      return null;
    } catch (e) {
      print('Error in vectorSearch: $e');
      return null;
    }
  }

  /// Convert image file to bitmap rgba
  static Future<Map<String, dynamic>?> convertImageFileToBitmapRgba(
    String imagePath,
  ) async {
    final image = await img.decodeImageFile(imagePath);
    if (image?.data == null) {
      return null;
    }
    return convertImageToBitmap(image);
  }

  static Map<String, dynamic> convertImageToBitmap(img.Image? image) {
    List<int> bitmap = [];
    for (int y = 0; y < image!.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixelClamped(x, y);
        bitmap.add(
          img.rgbaToUint32(
            pixel.b.toInt(),
            pixel.g.toInt(),
            pixel.r.toInt(),
            pixel.a.toInt(),
          ),
        );
      }
    }
    return {'bitmap': bitmap, 'width': image.width, 'height': image.height};
  }

  /// Convert image to face vector
  Future<List<double>?> convertImageFileToFaceVector(String imagePath) async {
    final bitmap = await compute(convertImageFileToBitmapRgba, imagePath);
    if (bitmap == null) {
      return null;
    }
    final faceVector = await ViFaceCore.faceToVector(
      bitmap['bitmap'],
      bitmap['width'],
      bitmap['height'],
    );
    return faceVector;
  }

  /// Add a new face to the database with vector
  Future<bool> addFace(
    int personId,
    String imagePath,
    List<double> vector,
  ) async {
    try {
      // Convert image to vector
      final face = Face(
        personId: personId,
        path: imagePath,
        vector: vector,
        updatedTime: DateTime.now(),
      );

      // Save to database
      await _databaseHelper.insertFace(face);
      ViFaceCore.buildVectorData();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get recognition result with face information
  Future<RecognitionResult?> recognizeWithFace(
    Map<String, dynamic> bitmap,
  ) async {
    try {
      final result = await ViFaceCore.faceRecognition(
        bitmap['bitmap'],
        bitmap['width'],
        bitmap['height'],
      );

      if (result == null) {
        return null; // Invalid face image
      }

      final faceId = result['id'] as int;
      final confidence = result['distance'] as double;
      if (faceId == -1) {
        return null;
      }
      if (confidence > 1.1) {
        return RecognitionResult(
          person: null,
          recognizedFace: null,
          queryVector: Float32List.fromList([]),
          confidence: confidence, // This would come from the actual AI function
        );
      }
      // Get face details
      final faces = await _databaseHelper.getAllFaces();
      final face = faces.firstWhere((f) => f.id == faceId);

      // Get person details
      final person = await _databaseHelper.getPersonById(face.personId);
      if (person == null) {
        return RecognitionResult(
          person: null,
          recognizedFace: face,
          queryVector: Float32List.fromList([]),
          confidence: confidence, // This would come from the actual AI function
        );
      }

      return RecognitionResult(
        person: person,
        recognizedFace: face,
        confidence: confidence, // This would come from the actual AI function
      );
    } catch (e) {
      print('Error in recognition with face: $e');
      return null;
    }
  }
}

/// Result class for face recognition
class RecognitionResult {
  final Person? person;
  final Face? recognizedFace;
  final Float32List? queryVector;
  final double confidence;

  RecognitionResult({
    this.person,
    this.recognizedFace,
    this.queryVector,
    this.confidence = 0.0,
  });
}
