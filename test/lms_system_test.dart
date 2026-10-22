import 'package:test/test.dart';
import 'package:lms_layered_architecture_example/service/lms_system.dart';

void main() {
  test('manages courses, enrollments, and results', () {
    final lms = LmsSystem()
      ..addStudent(studentId: 'S1', studentName: 'Ronan')
      ..addStudent(studentId: 'S2', studentName: 'Dara')
      ..addCourse(courseId: 'C1', courseName: 'Dart')
      ..addCourse(courseId: 'C2', courseName: 'Flutter')
      ..enrollStudent(studentId: 'S1', courseId: 'C1')
      ..enrollStudent(studentId: 'S2', courseId: 'C1')
      ..enrollStudent(studentId: 'S1', courseId: 'C2');

    lms
      ..addResult(
        resultId: 'R1',
        studentId: 'S1',
        courseId: 'C1',
        score: 85,
      )
      ..addResult(
        resultId: 'R2',
        studentId: 'S2',
        courseId: 'C1',
        score: 90,
      )
      ..addResult(
        resultId: 'R3',
        studentId: 'S1',
        courseId: 'C2',
        score: 75,
      );

    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');
    expect(lms.results.map((r) => r.id), ['R2', 'R3']);
    expect(lms.students.length, 2);

    lms
      ..enrollStudent(studentId: 'S1', courseId: 'C1')
      ..removeStudent(studentId: 'S1');
    expect(lms.students.map((s) => s.id), ['S2']);
    expect(lms.courses.map((c) => c.studentIds), [
      ['S2'],
      [],
    ]);
    expect(lms.results.map((r) => r.id), ['R2']);

    lms
      ..removeResult(resultId: 'R2')
      ..removeCourse(courseId: 'C1');
    expect(lms.results, isEmpty);
    expect(lms.courses.map((c) => c.id), ['C2']);
  });

  test('rejects duplicates, missing records, and invalid scores', () {
    final lms = LmsSystem()
      ..addStudent(studentId: 'S1', studentName: 'Ronan')
      ..addCourse(courseId: 'C1', courseName: 'Dart')
      ..enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(() => lms.addStudent(studentId: 'S1', studentName: 'Other'),
        throwsStateError);
    expect(() => lms.addCourse(courseId: 'C1', courseName: 'Other'),
        throwsStateError);
    expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C1'),
        throwsStateError);
    expect(
        () => lms.addResult(
              resultId: 'R1',
              studentId: 'S1',
              courseId: 'C1',
              score: 101,
            ),
        throwsArgumentError);
    expect(() => lms.removeStudent(studentId: 'missing'), throwsStateError);
    expect(() => lms.removeCourse(courseId: 'missing'), throwsStateError);
    expect(() => lms.removeResult(resultId: 'missing'), throwsStateError);
  });
}
