import '../models/lesson.dart';

class LessonService {
  // Mock data for lessons - replace with actual API calls
  static List<Lesson> getMockLessons() {
    return [
      Lesson(
        id: '1',
        title: 'Cách cầm bóng cơ bản',
        description: 'Học cách cầm bóng đúng kỹ thuật để có thể kiểm soát bóng tốt hơn',
        videoUrl: 'https://videos.pexels.com/video-files/856188/856188-hd_1920_1080_30fps.mp4',
        teacherName: 'Coach Nguyễn Văn A',
        thumbnailUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxp5pThZThqhNr_3BzZrZz9UqFqYiemS1pBA&s',
        duration: 15,
        difficulty: 'beginner',
        tags: ['cầm bóng', 'cơ bản', 'kỹ thuật'],
      ),
      Lesson(
        id: '2',
        title: 'Dribbling cơ bản',
        description: 'Kỹ thuật dẫn bóng cơ bản cho người mới bắt đầu',
        videoUrl: 'https://videos.pexels.com/video-files/856188/856188-hd_1920_1080_30fps.mp4',
        teacherName: 'Coach Trần Thị B',
        thumbnailUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxp5pThZThqhNr_3BzZrZz9UqFqYiemS1pBA&s',
        duration: 20,
        difficulty: 'beginner',
        tags: ['dribbling', 'dẫn bóng', 'cơ bản'],
      ),
      Lesson(
        id: '3',
        title: 'Shooting cơ bản',
        description: 'Học cách ném bóng vào rổ với kỹ thuật chuẩn',
        videoUrl: 'https://videos.pexels.com/video-files/856188/856188-hd_1920_1080_30fps.mp4',
        teacherName: 'Coach Lê Văn C',
        thumbnailUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxp5pThZThqhNr_3BzZrZz9UqFqYiemS1pBA&s',
        duration: 25,
        difficulty: 'beginner',
        tags: ['shooting', 'ném bóng', 'cơ bản'],
      ),
      Lesson(
        id: '4',
        title: 'Passing và nhận bóng',
        description: 'Kỹ thuật chuyền bóng và nhận bóng hiệu quả',
        videoUrl: 'https://videos.pexels.com/video-files/856188/856188-hd_1920_1080_30fps.mp4',
        teacherName: 'Coach Phạm Thị D',
        thumbnailUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxp5pThZThqhNr_3BzZrZz9UqFqYiemS1pBA&s',
        duration: 18,
        difficulty: 'intermediate',
        tags: ['passing', 'chuyền bóng', 'nhận bóng'],
      ),
      Lesson(
        id: '5',
        title: 'Defense cơ bản',
        description: 'Kỹ thuật phòng thủ cơ bản trong bóng rổ',
        videoUrl: 'https://videos.pexels.com/video-files/856188/856188-hd_1920_1080_30fps.mp4',
        teacherName: 'Coach Hoàng Văn E',
        thumbnailUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxp5pThZThqhNr_3BzZrZz9UqFqYiemS1pBA&s',
        duration: 22,
        difficulty: 'intermediate',
        tags: ['defense', 'phòng thủ', 'kỹ thuật'],
      ),
    ];
  }
  
  static Future<List<Lesson>> getLessons() async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 500));
    return getMockLessons();
  }
  
  static Future<Lesson?> getLessonById(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    final lessons = getMockLessons();
    try {
      return lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }
  
  static List<Lesson> getLessonsByDifficulty(String difficulty) {
    final lessons = getMockLessons();
    return lessons.where((lesson) => lesson.difficulty == difficulty).toList();
  }
  
  static List<Lesson> searchLessons(String query) {
    final lessons = getMockLessons();
    return lessons.where((lesson) {
      return lesson.title.toLowerCase().contains(query.toLowerCase()) ||
             lesson.description.toLowerCase().contains(query.toLowerCase()) ||
             lesson.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }
}
