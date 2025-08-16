class Lesson {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String teacherName;
  final String thumbnailUrl;
  final int duration; // in minutes
  final String difficulty; // beginner, intermediate, advanced
  final List<String> tags;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.teacherName,
    required this.thumbnailUrl,
    required this.duration,
    required this.difficulty,
    required this.tags,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      teacherName: json['teacherName'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      duration: json['duration'] ?? 0,
      difficulty: json['difficulty'] ?? 'beginner',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'teacherName': teacherName,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'difficulty': difficulty,
      'tags': tags,
    };
  }
}
