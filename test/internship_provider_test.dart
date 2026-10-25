
import 'package:flutter_test/flutter_test.dart';
import 'package:internship_tracker/models/internship.dart';
import 'package:internship_tracker/providers/internship_provider.dart';

void main() {
  late InternshipProvider provider;

  Internship createInternship({
    String id = '1',
    String company = 'Google',
    InternshipStatus status = InternshipStatus.applied,
  }) {
    return Internship(
      id: id,
      company: company,
      role: 'Software Engineer Intern',
      location: 'Bangalore',
      type: 'Internship',
      appliedDate: DateTime(2026, 10, 25),
      status: status,
    );
  }

  setUp(() {
    provider = InternshipProvider();
  });

  tearDown(() {
    provider.dispose();
  });

  test('adds an internship and updates total count', () {
    provider.addInternship(createInternship());

    expect(provider.totalCount, 1);
    expect(provider.internships.first.company, 'Google');
    expect(provider.appliedCount, 1);
  });

  test('updates internship details and status counts', () {
    provider.addInternship(createInternship());

    final updated = createInternship(
      company: 'Google',
      status: InternshipStatus.interview,
    );

    provider.updateInternship(updated);

    expect(provider.totalCount, 1);
    expect(provider.appliedCount, 0);
    expect(provider.interviewCount, 1);
    expect(provider.internships.first.status,
        InternshipStatus.interview);
  });

  test('deletes an internship', () {
    provider.addInternship(createInternship());

    provider.deleteInternship('1');

    expect(provider.totalCount, 0);
    expect(provider.internships, isEmpty);
  });

  test('searches by company, role, and location', () {
    provider.addInternship(createInternship());

    expect(provider.search('google').length, 1);
    expect(provider.search('ENGINEER').length, 1);
    expect(provider.search('bangalore').length, 1);
    expect(provider.search('Microsoft'), isEmpty);
  });

  test('returns all internships for an empty search', () {
    provider.addInternship(createInternship());
    provider.addInternship(
      createInternship(id: '2', company: 'Microsoft'),
    );

    expect(provider.search('').length, 2);
    expect(provider.search('   ').length, 2);
  });

  test('does not add an unknown internship when updating', () {
    provider.updateInternship(createInternship());

    expect(provider.totalCount, 0);
  });
}
