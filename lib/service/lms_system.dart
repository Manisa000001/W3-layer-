import '../model/course.dart';
import '../model/courseresult.dart';
import '../model/student.dart';

class LmsSystem {
  final students = <Student>[];
  final courses = <Course>[];
  final results = <CourseResult>[];

  Student _student(String id) => students.firstWhere(
        (s) => s.id == id,
        orElse: () => throw StateError('Student not found.'),
      );

  Course _course(String id) => courses.firstWhere(
        (c) => c.id == id,
        orElse: () => throw StateError('Course not found.'),
      );

  void addStudent({required String studentId, required String studentName}) {
    if (students.any((s) => s.id == studentId)) {
      throw StateError('Student already exists.');
    }
    students.add(Student(id: studentId, name: studentName));
  }

  void removeStudent({required String studentId}) {
    _student(studentId);
    students.removeWhere((s) => s.id == studentId);
    for (final c in courses) {
      c.studentIds.remove(studentId);
    }
    results.removeWhere((r) => r.studentId == studentId);
  }

  void addCourse({required String courseId, required String courseName}) {
    if (courses.any((c) => c.id == courseId)) {
      throw StateError('Course already exists.');
    }
    courses.add(Course(id: courseId, name: courseName));
  }

  void removeCourse({required String courseId}) {
    _course(courseId);
    courses.removeWhere((c) => c.id == courseId);
    results.removeWhere((r) => r.courseId == courseId);
  }

  void enrollStudent({required String studentId, required String courseId}) {
    _student(studentId);
    final c = _course(courseId);
    if (c.studentIds.contains(studentId)) {
      throw StateError('Already enrolled.');
    }
    c.studentIds.add(studentId);
  }

  void discardStudentFromCourse({
    required String studentId,
    required String courseId,
  }) {
    _student(studentId);
    if (!_course(courseId).studentIds.remove(studentId)) {
      throw StateError('Enrollment not found.');
    }
    results
        .removeWhere((r) => r.studentId == studentId && r.courseId == courseId);
  }

  void addResult({
    required String resultId,
    required String studentId,
    required String courseId,
    required double score,
  }) {
    _student(studentId);
    if (!_course(courseId).studentIds.contains(studentId)) {
      throw StateError('Student is not enrolled.');
    }
    if (results.any((r) => r.id == resultId)) {
      throw StateError('Result already exists.');
    }
    if (!score.isFinite || score < 0 || score > 100) {
      throw ArgumentError('Score must be 0-100.');
    }
    results.add(CourseResult(
      id: resultId,
      studentId: studentId,
      courseId: courseId,
      score: score,
    ));
  }

  void removeResult({required String resultId}) {
    final result = results.where((r) => r.id == resultId);
    if (result.isEmpty) throw StateError('Result not found.');
    results.remove(result.first);
  }
}
