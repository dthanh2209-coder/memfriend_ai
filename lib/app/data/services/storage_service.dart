import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static StorageService? _instance;
  
  StorageService._internal();

  factory StorageService() {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  /// Get the app's document directory
  Future<Directory> get _appDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    return appDir;
  }

  /// Get the faces directory
  Future<Directory> get _facesDirectory async {
    final appDir = await _appDirectory;
    final facesDir = Directory(join(appDir.path, 'faces'));
    if (!await facesDir.exists()) {
      await facesDir.create(recursive: true);
    }
    return facesDir;
  }

  /// Get the memory events directory
  Future<Directory> get _memoryEventsDirectory async {
    final appDir = await _appDirectory;
    final memoryDir = Directory(join(appDir.path, 'memory_events'));
    if (!await memoryDir.exists()) {
      await memoryDir.create(recursive: true);
    }
    return memoryDir;
  }

  /// Save face image and return the file path
  Future<String?> saveFaceImage(String sourcePath, int personId) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        return null;
      }

      final facesDir = await _facesDirectory;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = extension(sourcePath);
      final fileName = 'face_${personId}_$timestamp$fileExtension';
      final targetPath = join(facesDir.path, fileName);
      
      await sourceFile.copy(targetPath);
      return targetPath;
    } catch (e) {
      print('Error saving face image: $e');
      return null;
    }
  }

  /// Save face image from bytes and return the file path
  Future<String?> saveFaceImageFromBytes(Uint8List bytes, int personId, String extension) async {
    try {
      final facesDir = await _facesDirectory;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'face_${personId}_$timestamp.$extension';
      final targetPath = join(facesDir.path, fileName);
      
      final file = File(targetPath);
      await file.writeAsBytes(bytes);
      return targetPath;
    } catch (e) {
      print('Error saving face image from bytes: $e');
      return null;
    }
  }

  /// Save memory event image and return the file path
  Future<String?> saveMemoryEventImage(String sourcePath, int personId) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        return null;
      }

      final memoryDir = await _memoryEventsDirectory;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = extension(sourcePath);
      final fileName = 'memory_${personId}_$timestamp$fileExtension';
      final targetPath = join(memoryDir.path, fileName);
      
      await sourceFile.copy(targetPath);
      return targetPath;
    } catch (e) {
      print('Error saving memory event image: $e');
      return null;
    }
  }

  /// Save memory event image from bytes and return the file path
  Future<String?> saveMemoryEventImageFromBytes(Uint8List bytes, int personId, String extension) async {
    try {
      final memoryDir = await _memoryEventsDirectory;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'memory_${personId}_$timestamp.$extension';
      final targetPath = join(memoryDir.path, fileName);
      
      final file = File(targetPath);
      await file.writeAsBytes(bytes);
      return targetPath;
    } catch (e) {
      print('Error saving memory event image from bytes: $e');
      return null;
    }
  }

  /// Delete file
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  /// Check if file exists
  Future<bool> fileExists(String filePath) async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      print('Error checking file existence: $e');
      return false;
    }
  }

  /// Get file size
  Future<int?> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      print('Error getting file size: $e');
      return null;
    }
  }

  /// Clean up orphaned files (files that are not referenced in database)
  Future<void> cleanupOrphanedFiles() async {
    try {
      // This would require database integration to check which files are still referenced
      // Implementation would compare files in directories with database records
      print('Cleanup orphaned files - to be implemented with database integration');
    } catch (e) {
      print('Error cleaning up orphaned files: $e');
    }
  }

  /// Get total storage usage
  Future<int> getTotalStorageUsage() async {
    try {
      int totalSize = 0;
      
      final facesDir = await _facesDirectory;
      final memoryDir = await _memoryEventsDirectory;
      
      // Calculate faces directory size
      if (await facesDir.exists()) {
        await for (final entity in facesDir.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
      
      // Calculate memory events directory size
      if (await memoryDir.exists()) {
        await for (final entity in memoryDir.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
      
      return totalSize;
    } catch (e) {
      print('Error calculating storage usage: $e');
      return 0;
    }
  }
}
