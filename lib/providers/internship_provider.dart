
import 'package:flutter/foundation.dart';

import '../models/internship.dart';

class InternshipProvider extends ChangeNotifier {
  final List<Internship> _internships = [];

  List<Internship> get internships => List.unmodifiable(_internships);

  int get totalCount => _internships.length;

  int get appliedCount => _countByStatus(InternshipStatus.applied);

  int get assessmentCount => _countByStatus(InternshipStatus.assessment);

  int get interviewCount => _countByStatus(InternshipStatus.interview);

  int get selectedCount => _countByStatus(InternshipStatus.selected);

  int get rejectedCount => _countByStatus(InternshipStatus.rejected);

  int _countByStatus(InternshipStatus status) {
    return _internships.where((item) => item.status == status).length;
  }

  void addInternship(Internship internship) {
    _internships.add(internship);
    notifyListeners();
  }

  void updateInternship(Internship updated) {
    final index = _internships.indexWhere((item) => item.id == updated.id);

    if (index == -1) return;

    _internships[index] = updated;
    notifyListeners();
  }

  void deleteInternship(String id) {
    _internships.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Internship? getById(String id) {
    for (final internship in _internships) {
      if (internship.id == id) return internship;
    }
    return null;
  }

  List<Internship> search(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) return internships;

    return _internships.where((item) {
      return item.company.toLowerCase().contains(normalizedQuery) ||
          item.role.toLowerCase().contains(normalizedQuery) ||
          item.location.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}
