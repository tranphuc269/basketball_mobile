class UserProgress {
  final String lessonId;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? practiceVideoUrl;
  final int practiceCount;
  final DateTime lastPracticed;

  UserProgress({
    required this.lessonId,
    this.isCompleted = false,
    this.completedAt,
    this.practiceVideoUrl,
    this.practiceCount = 0,
    required this.lastPracticed,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      lessonId: json['lessonId'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      practiceVideoUrl: json['practiceVideoUrl'],
      practiceCount: json['practiceCount'] ?? 0,
      lastPracticed: DateTime.parse(json['lastPracticed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'practiceVideoUrl': practiceVideoUrl,
      'practiceCount': practiceCount,
      'lastPracticed': lastPracticed.toIso8601String(),
    };
  }

  UserProgress copyWith({
    String? lessonId,
    bool? isCompleted,
    DateTime? completedAt,
    String? practiceVideoUrl,
    int? practiceCount,
    DateTime? lastPracticed,
  }) {
    return UserProgress(
      lessonId: lessonId ?? this.lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      practiceVideoUrl: practiceVideoUrl ?? this.practiceVideoUrl,
      practiceCount: practiceCount ?? this.practiceCount,
      lastPracticed: lastPracticed ?? this.lastPracticed,
    );
  }
}
