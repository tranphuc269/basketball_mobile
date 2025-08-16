import 'package:get/get.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';

class LessonController extends GetxController {
  var lessons = <Lesson>[].obs;
  var isLoading = false.obs;
  var selectedLesson = Rxn<Lesson>();
  var searchQuery = ''.obs;
  var filteredLessons = <Lesson>[].obs;
  var selectedDifficulty = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadLessons();
  }

  Future<void> loadLessons() async {
    isLoading.value = true;
    try {
      final lessonList = await LessonService.getLessons();
      lessons.value = lessonList;
      filteredLessons.value = lessonList;
    } catch (e) {
      print('Error loading lessons: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectLesson(Lesson lesson) {
    selectedLesson.value = lesson;
  }

  void clearSelectedLesson() {
    selectedLesson.value = null;
  }

  void searchLessons(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredLessons.value = lessons;
    } else {
      filteredLessons.value = LessonService.searchLessons(query);
    }
  }

  void filterByDifficulty(String difficulty) {
    selectedDifficulty.value = difficulty;
    if (difficulty == 'all') {
      filteredLessons.value = lessons;
    } else {
      filteredLessons.value = LessonService.getLessonsByDifficulty(difficulty);
    }
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedDifficulty.value = 'all';
    filteredLessons.value = lessons;
  }

  List<String> get availableDifficulties {
    final difficulties = lessons.map((lesson) => lesson.difficulty).toSet().toList();
    difficulties.insert(0, 'all');
    return difficulties;
  }
}
