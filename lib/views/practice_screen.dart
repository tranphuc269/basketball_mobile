import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../models/lesson.dart';
import '../controllers/camera_controller.dart';

class PracticeScreen extends StatelessWidget {
  final Lesson lesson;

  const PracticeScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraController = Get.find<BasketballCameraController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thực hành: ${lesson.title}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF1E3A8A),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Camera Preview
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Obx(() {
                        if (!cameraController.isInitialized.value) {
                          return Container(
                            color: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Đang khởi tạo camera...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        if (cameraController.cameraController != null) {
                          return CameraPreview(cameraController.cameraController!);
                        }
                        
                        return Container(
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              'Không thể hiển thị camera',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                
                SizedBox(height: 30),
                
                // Recording Controls
                Obx(() {
                  if (cameraController.isRecording.value) {
                    return _buildRecordingControls(cameraController);
                  } else if (cameraController.hasRecordedVideo) {
                    return _buildVideoReviewControls(cameraController);
                  } else {
                    return _buildInitialControls(cameraController);
                  }
                }),
                
                SizedBox(height: 20),
                
                // Instructions
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Hướng dẫn thực hành',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '1. Xem video bài học trước khi thực hành\n'
                        '2. Đặt camera ở vị trí phù hợp\n'
                        '3. Thực hiện động tác theo hướng dẫn\n'
                        '4. Quay video và gửi lên để được đánh giá',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialControls(BasketballCameraController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Switch Camera Button
        if (controller.cameras.length > 1)
          FloatingActionButton(
            onPressed: controller.switchCamera,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(Icons.switch_camera, color: Colors.white),
          ),
        
        // Record Button
        FloatingActionButton.large(
          onPressed: controller.canRecord ? controller.startRecording : null,
          backgroundColor: Colors.red,
          child: Icon(
            Icons.fiber_manual_record,
            color: Colors.white,
            size: 32,
          ),
        ),
        
        // Placeholder for symmetry
        if (controller.cameras.length <= 1)
          SizedBox(width: 56),
      ],
    );
  }

  Widget _buildRecordingControls(BasketballCameraController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop Recording Button
        FloatingActionButton.large(
          onPressed: controller.canStopRecording ? controller.stopRecording : null,
          backgroundColor: Colors.red,
          child: Icon(
            Icons.stop,
            color: Colors.white,
            size: 32,
          ),
        ),
        
        SizedBox(width: 20),
        
        // Recording Indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Đang ghi...',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoReviewControls(BasketballCameraController controller) {
    return Column(
      children: [
        // Video Preview
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Icon(
                Icons.videocam,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        SizedBox(height: 20),
        
        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Retake Button
            Expanded(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    controller.clearRecordedVideo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, size: 20),
                      SizedBox(width: 8),
                      Text('Quay lại'),
                    ],
                  ),
                ),
              ),
            ),
            
            // Upload Button
            Expanded(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(left: 10),
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isUploading.value 
                      ? null 
                      : controller.uploadVideoToS3,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: controller.isUploading.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Đang upload...'),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 20),
                            SizedBox(width: 8),
                            Text('Lưu video'),
                          ],
                        ),
                )),
              ),
            ),
          ],
        ),
        
        // Upload Progress
        if (controller.isUploading.value) ...[
          SizedBox(height: 20),
          Obx(() => LinearProgressIndicator(
            value: controller.uploadProgress.value,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )),
        ],
      ],
    );
  }
}
