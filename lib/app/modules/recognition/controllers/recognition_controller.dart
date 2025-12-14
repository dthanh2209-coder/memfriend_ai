import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mem_friend/app/core/utils/image_utils.dart';
import 'package:mem_friend/app/data/models/face.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/values/app_strings.dart';
import '../../../data/models/person.dart';
import '../../../data/services/face_recognition_service.dart';

enum RecognitionMode { live, image }

class RecognitionController extends GetxController {
  final FaceRecognitionService _faceRecognitionService =
      FaceRecognitionService();
  final ImagePicker _imagePicker = ImagePicker();
  final FlutterTts _flutterTts = FlutterTts();

  // Camera related
  CameraController? cameraController;
  final RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  final RxInt selectedCameraIndex = 0.obs;
  final RxBool isCameraInitialized = false.obs;

  // Recognition mode
  final Rx<RecognitionMode> recognitionMode = RecognitionMode.live.obs;

  // Image mode
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<Uint8List?> uiImage = Rx<Uint8List?>(null);

  // Recognition results
  final Rx<Person?> recognizedPerson = Rx<Person?>(null);
  final Rx<Face?> recognizedPersonFace = Rx<Face?>(null);
  final RxBool isRecognizing = false.obs;
  final RxString recognitionMessage = ''.obs;

  // Permissions
  final RxBool hasCameraPermission = false.obs;

  CameraImage? currentCameraImage;
  DateTime? lastProcessingTime;
  static const Duration processingThrottle = Duration(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    _initializeTts();
    _initializeCameras();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    _flutterTts.stop();
    super.onClose();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('vi-VN'); // Vietnamese
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    hasCameraPermission.value = cameraStatus.isGranted;

    if (!hasCameraPermission.value) {
      Get.snackbar(
        AppStrings.permissionRequired.tr,
        AppStrings.cameraPermissionDenied.tr,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> _initializeCameras() async {
    await checkPermissions();
    if (!hasCameraPermission.value) return;

    try {
      cameras.value = await availableCameras();
      if (cameras.isNotEmpty) {
        await _initializeCamera(0);
      }
    } catch (e) {
      print('Error initializing cameras: $e');
    }
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    if (cameras.isEmpty) return;

    try {
      // Dispose previous controller if exists
      await cameraController?.dispose();

      cameraController = CameraController(
        cameras[cameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      cameraController?.startImageStream((CameraImage image) async {
        if (recognitionMode.value == RecognitionMode.live) {
          if (currentCameraImage != null) {
            return;
          }
          currentCameraImage = image;
          lastProcessingTime = DateTime.now();
          await _processLiveCameraImage(image, cameraIndex);
        }
      });
      isCameraInitialized.value = true;
      selectedCameraIndex.value = cameraIndex;
      isCameraInitialized.refresh();
    } catch (e) {
      print('Error initializing camera: $e');
      isCameraInitialized.value = false;
    }
  }

  /// Process live camera image with throttling
  Future<void> _processLiveCameraImage(
    CameraImage image,
    int cameraIndex,
  ) async {
    // final now = DateTime.now();
    // if (lastProcessingTime != null &&
    //     now.difference(lastProcessingTime!) < processingThrottle) {
    //   return; // Skip processing to prevent excessive calls
    // }

    final res = convertYUV420ToImage({
      'cameraImage': image,
      'cameraId': cameraIndex,
    });
    final bitmap = FaceRecognitionService.convertImageToBitmap(res);
    await _recognizeFromBitmap(bitmap, mode: RecognitionMode.live);
    // final pngBytes = img.encodeBmp(res);
    // uiImage.value = pngBytes;
    await Future.delayed(const Duration(milliseconds: 300));
    currentCameraImage = null;
  }

  /// Switch between live and image mode
  void switchMode() {
    recognitionMode.value = recognitionMode.value == RecognitionMode.live
        ? RecognitionMode.image
        : RecognitionMode.live;

    // Clear previous results
    isRecognizing.value = false;
    recognizedPerson.value = null;
    recognitionMessage.value = '';

    if (recognitionMode.value == RecognitionMode.image) {
      selectedImage.value = null;
    }
    if (recognitionMode.value == RecognitionMode.live) {
      currentCameraImage = null;
      // restart camera
      Future.delayed(const Duration(milliseconds: 200), () {
        _initializeCamera(selectedCameraIndex.value);
      });
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (cameras.length < 2) return;

    final newIndex = (selectedCameraIndex.value + 1) % 2;
    await _initializeCamera(newIndex);
  }

  /// Take photo from camera or select from gallery
  Future<void> selectImage({bool fromCamera = false}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        // reset results
        isRecognizing.value = false;
        recognizedPerson.value = null;
        recognitionMessage.value = '';
        selectedImage.value = File(image.path);
        // Automatically recognize when image is selected
        final bitmap =
            await FaceRecognitionService.convertImageFileToBitmapRgba(
              image.path,
            );
        await _recognizeFromBitmap(bitmap!, mode: RecognitionMode.image);
      }
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        '${AppStrings.failedToPickImage.tr}: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  /// Show image source selection dialog
  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.selectImageSource.tr,
                style: Get.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        selectImage(fromCamera: true);
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: Text(AppStrings.camera.tr),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        selectImage(fromCamera: false);
                      },
                      icon: const Icon(Icons.photo_library),
                      label: Text(AppStrings.gallery.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Recognize person from selected image
  Future<void> _recognizeFromBitmap(
    Map<String, dynamic> bitmap, {
    RecognitionMode mode = RecognitionMode.live,
  }) async {
    try {
      // isRecognizing.value = true;
      // recognitionMessage.value = AppStrings.recognizing.tr;

      final result = await _faceRecognitionService.recognizeWithFace(bitmap);
      // if not live mode, return
      if (recognitionMode.value != mode) return;

      if (result?.person != null) {
        // Check person
        if (result!.person!.id != recognizedPerson.value?.id) {
          recognizedPerson.value = result.person!;
          recognizedPersonFace.value = result.recognizedFace;
          recognitionMessage.value = '';
          await speakRecognitionResult(result.person!);
        }
      } else {
        if (result?.queryVector != null || recognizedPerson.value == null) {
          recognizedPerson.value = null;
          recognizedPersonFace.value = null;
          recognitionMessage.value = AppStrings.noPersonFound.tr;
        }
      }
    } catch (e) {
      recognitionMessage.value = '${AppStrings.recognitionFailed.tr}: $e';
      recognizedPerson.value = null;
      recognizedPersonFace.value = null;
    } finally {
      // isRecognizing.value = false;
    }
  }

  /// Speak recognition result in Vietnamese|
  Future<void> speakRecognitionResult(Person person) async {
    try {
      final text =
          '${person.relation?.isNotEmpty == true ? '${person.relation}' : ''} ${person.name}';
      await _flutterTts.speak(text);
    } catch (e) {
      print('TTS Error: $e');
    }
  }

  /// Navigate to person detail
  void goToPersonDetail() {
    if (recognizedPerson.value != null) {
      Get.toNamed('/person-detail', arguments: recognizedPerson.value);
    }
  }

  /// Navigate to home
  void goToHome() {
    Get.offAllNamed('/home');
  }

  /// Navigate to settings
  void goToSettings() {
    Get.offAllNamed('/settings');
  }

  /// Get recognition mode title
  String get modeTitle => recognitionMode.value == RecognitionMode.live
      ? AppStrings.liveMode.tr
      : AppStrings.imageMode.tr;

  /// Get camera switch icon
  IconData get cameraSwitchIcon => recognitionMode.value == RecognitionMode.live
      ? Icons.switch_camera
      : Icons.image;
}
