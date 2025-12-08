import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:mem_friend/app/core/theme/app_theme.dart';

class ImageUtils {
  /// Resize image to maximum dimensions while maintaining aspect ratio
  static Future<File?> resizeImage(
    File imageFile,
    int maxWidth,
    int maxHeight, {
    int quality = 85,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      // Calculate new dimensions
      int newWidth = image.width;
      int newHeight = image.height;

      if (newWidth > maxWidth || newHeight > maxHeight) {
        final aspectRatio = newWidth / newHeight;

        if (aspectRatio > 1) {
          // Landscape
          newWidth = maxWidth;
          newHeight = (maxWidth / aspectRatio).round();
        } else {
          // Portrait
          newHeight = maxHeight;
          newWidth = (maxHeight * aspectRatio).round();
        }
      }

      // Resize image
      final resizedImage = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
      );

      // Encode as JPEG with specified quality
      final compressedBytes = img.encodeJpg(resizedImage, quality: quality);

      // Write to file
      await imageFile.writeAsBytes(compressedBytes);
      return imageFile;
    } catch (e) {
      print('Error resizing image: $e');
      return null;
    }
  }

  /// Compress image file
  static Future<File?> compressImage(
    File imageFile, {
    int quality = 85,
    int maxWidth = 1024,
    int maxHeight = 1024,
  }) async {
    return await resizeImage(imageFile, maxWidth, maxHeight, quality: quality);
  }

  /// Get image dimensions
  static Future<Size?> getImageDimensions(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return null;

      return Size(image.width.toDouble(), image.height.toDouble());
    } catch (e) {
      print('Error getting image dimensions: $e');
      return null;
    }
  }

  /// Check if file is a valid image
  static Future<bool> isValidImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      return image != null;
    } catch (e) {
      return false;
    }
  }
}

class Size {
  final double width;
  final double height;

  Size(this.width, this.height);

  @override
  String toString() => 'Size($width, $height)';
}

void showFullScreenImage(String imagePath) {
  if (imagePath.isEmpty) return;
  Get.dialog(
    Dialog(
      backgroundColor: Colors.black,
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
          ),
          Flexible(
            child: InteractiveViewer(
              clipBehavior: Clip.hardEdge,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    ),
  );
}

img.Image convertYUV420ToImage(Map<String, dynamic> map) {
  final cameraImage = map['cameraImage'] as CameraImage;
  final cameraId = map['cameraId'] as int;
  final width = cameraImage.width;
  final height = cameraImage.height;

  final uvRowStride = cameraImage.planes[1].bytesPerRow;
  final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

  final yPlane = cameraImage.planes[0].bytes;
  final uPlane = cameraImage.planes[1].bytes;
  final vPlane = cameraImage.planes[2].bytes;

  final image = img.Image(width: height, height: width);

  var uvIndex = 0;

  for (var y = 0; y < height; y++) {
    var pY = y * width;
    var pUV = uvIndex;

    for (var x = 0; x < width; x++) {
      final yValue = yPlane[pY];
      final uValue = uPlane[pUV];
      final vValue = vPlane[pUV];

      final r = yValue + 1.402 * (vValue - 128);
      final g = yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128);
      final b = yValue + 1.772 * (uValue - 128);
      if (cameraId == 0) {
        image.setPixelRgba(
          height - y - 1,
          x,
          r.toInt(),
          g.toInt(),
          b.toInt(),
          255,
        );
      } else {
        image.setPixelRgba(
          height - y - 1,
          width - x - 1,
          r.toInt(),
          g.toInt(),
          b.toInt(),
          255,
        );
      }

      pY++;
      if (x % 2 == 1 && uvPixelStride == 2) {
        pUV += uvPixelStride;
      } else if (x % 2 == 1 && uvPixelStride == 1) {
        pUV++;
      }
    }

    if (y % 2 == 1) {
      uvIndex += uvRowStride;
    }
  }
  return image;
}
