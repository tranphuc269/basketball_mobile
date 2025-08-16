import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../models/lesson.dart';
import '../controllers/camera_controller.dart';
import 'practice_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonDetailScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  VideoPlayerController? _videoPlayerController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.lesson.videoUrl),
      );
      print('widget.lesson.videoUrl :: ${widget.lesson.videoUrl}');
      
      await _videoPlayerController!.initialize();
      
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        Get.snackbar('Lỗi', 'Không thể tải video');
      }
    }
  }

  void _togglePlayPause() {
    if (_videoPlayerController != null) {
      setState(() {
        if (_isPlaying) {
          _videoPlayerController!.pause();
        } else {
          _videoPlayerController!.play();
        }
        _isPlaying = !_isPlaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Video
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Color(0xFF1E3A8A),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.black,
                child: _isVideoInitialized
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: _videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController!),
                          ),
                          // Play/Pause Button
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.fullscreen, color: Colors.white),
                onPressed: () {
                  // TODO: Implement fullscreen video
                },
              ),
            ],
          ),
          
          // Lesson Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Difficulty
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.lesson.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(widget.lesson.difficulty),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getDifficultyText(widget.lesson.difficulty),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Teacher Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF1E3A8A),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giáo viên',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            widget.lesson.teacherName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Duration and Tags
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                      SizedBox(width: 8),
                      Text(
                        '${widget.lesson.duration} phút',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.label, color: Colors.grey[600], size: 20),
                      SizedBox(width: 8),
                      Text(
                        '${widget.lesson.tags.length} tags',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Description
                  Text(
                    'Mô tả',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.lesson.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.lesson.tags.map((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF1E3A8A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xFF1E3A8A).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Practice Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // Initialize camera controller and navigate to practice screen
                        final cameraController = Get.put(BasketballCameraController());
                        cameraController.setLessonAndUser(
                          widget.lesson.id,
                          'user_123', // TODO: Get actual user ID
                        );
                        Get.to(() => PracticeScreen(lesson: widget.lesson));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: Color(0xFF1E3A8A).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'Vào học và quay video',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 'Cơ bản';
      case 'intermediate':
        return 'Trung cấp';
      case 'advanced':
        return 'Nâng cao';
      default:
        return difficulty;
    }
  }
}
