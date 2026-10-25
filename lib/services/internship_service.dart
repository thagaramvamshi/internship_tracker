
import '../models/internship.dart';

class InternshipService {
  const InternshipService();

  List<Internship> getAll(List<Internship> internships) {
    return List.unmodifiable(internships);
  }

  Internship? getById(
    List<Internship> internships,
    String id,
  ) {
    for (final internship in internships) {
      if (internship.id == id) {
        return internship;
      }
    }

    return null;
  }

  List<Internship> filterByStatus(
    List<Internship> internships,
    InternshipStatus status,
  ) {
    return internships
        .where((internship) => internship.status == status)
        .toList();
  }

  List<Internship> search(
    List<Internship> internships,
    String query,
  ) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return List.unmodifiable(internships);
    }

    return internships.where((internship) {
      return internship.company.toLowerCase().contains(normalizedQuery) ||
          internship.role.toLowerCase().contains(normalizedQuery) ||
          internship.location.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  bool exists(List<Internship> internships, String id) {
    return internships.any((internship) => internship.id == id);
  }
}
