import 'dart:io';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/s3_service.dart';

class BasketballCameraController extends GetxController {
  var cameras = <CameraDescription>[].obs;
  var selectedCameraIndex = 0.obs;
  var isInitialized = false.obs;
  var isRecording = false.obs;
  var recordedVideoPath = Rxn<String>();
  var isUploading = false.obs;
  var uploadProgress = 0.0.obs;
  
  CameraController? cameraController;
  late String lessonId;
  late String userId;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> initializeCamera() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        Get.snackbar('Lỗi', 'Cần quyền truy cập camera để ghi video');
        return;
      }

      // Get available cameras
      final availableCameraList = await availableCameras();
      cameras.value = availableCameraList;
      
      if (cameras.isNotEmpty) {
        await _initializeCameraController();
      }
    } catch (e) {
      print('Error initializing camera: $e');
      Get.snackbar('Lỗi', 'Không thể khởi tạo camera');
    }
  }

  Future<void> _initializeCameraController() async {
    try {
      cameraController = CameraController(
        cameras[selectedCameraIndex.value],
        ResolutionPreset.high,
      );

      await cameraController!.initialize();
      isInitialized.value = true;
    } catch (e) {
      print('Error initializing camera controller: $e');
    }
  }

  void switchCamera() {
    if (cameras.length > 1) {
      selectedCameraIndex.value = (selectedCameraIndex.value + 1) % cameras.length;
      _initializeCameraController();
    }
  }

  Future<void> startRecording() async {
    if (cameraController == null || !isInitialized.value) return;

    try {
      isRecording.value = true;
      await cameraController!.startVideoRecording();
    } catch (e) {
      print('Error starting recording: $e');
      isRecording.value = false;
    }
  }

  Future<void> stopRecording() async {
    if (cameraController == null) return;

    try {
      final file = await cameraController!.stopVideoRecording();
      recordedVideoPath.value = file.path;
      isRecording.value = false;
      
      Get.snackbar('Thành công', 'Video đã được ghi thành công!');
    } catch (e) {
      print('Error stopping recording: $e');
      isRecording.value = false;
    }
  }

  Future<void> uploadVideoToS3() async {
    if (recordedVideoPath.value == null) {
      Get.snackbar('Lỗi', 'Không có video để upload');
      return;
    }

    final videoFile = File(recordedVideoPath.value!);
    if (!S3Service.isValidVideoFile(videoFile)) {
      Get.snackbar('Lỗi', 'File video không hợp lệ');
      return;
    }

    isUploading.value = true;
    uploadProgress.value = 0.0;

    try {
      // Simulate upload progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(Duration(milliseconds: 200));
        uploadProgress.value = i / 100;
      }

      final s3Url = await S3Service.uploadVideoToS3(
        videoFile: videoFile,
        lessonId: lessonId,
        userId: userId,
      );

      if (s3Url != null) {
        Get.snackbar('Thành công', 'Video đã được upload lên S3 thành công!');
        // TODO: Save video URL to user progress
      } else {
        Get.snackbar('Lỗi', 'Không thể upload video lên S3');
      }
    } catch (e) {
      print('Error uploading video: $e');
      Get.snackbar('Lỗi', 'Có lỗi xảy ra khi upload video');
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0.0;
    }
  }

  void setLessonAndUser(String lessonId, String userId) {
    this.lessonId = lessonId;
    this.userId = userId;
  }

  void clearRecordedVideo() {
    recordedVideoPath.value = null;
  }

  bool get canRecord => isInitialized.value && !isRecording.value;
  bool get canStopRecording => isRecording.value;
  bool get hasRecordedVideo => recordedVideoPath.value != null;
}
