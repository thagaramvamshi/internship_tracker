
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/internship.dart';

class InternshipProvider extends ChangeNotifier {
  static const String _storageKey = 'internship_applications';

  final List<Internship> _internships = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  List<Internship> get internships =>
      List.unmodifiable(_internships);

  int get totalCount => _internships.length;

  int get appliedCount =>
      _internships.where((i) => i.status == InternshipStatus.applied).length;

  int get assessmentCount =>
      _internships.where((i) => i.status == InternshipStatus.assessment).length;

  int get interviewCount =>
      _internships.where((i) => i.status == InternshipStatus.interview).length;

  int get selectedCount =>
      _internships.where((i) => i.status == InternshipStatus.selected).length;

  int get rejectedCount =>
      _internships.where((i) => i.status == InternshipStatus.rejected).length;

  InternshipProvider() {
    loadInternships();
  }

  Future<void> loadInternships() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedData = prefs.getString(_storageKey);

      if (storedData != null) {
        final decoded = jsonDecode(storedData) as List<dynamic>;
        final loaded = decoded.map((item) {
          return Internship.fromJson(
            Map<String, dynamic>.from(item as Map),
          );
        }).toList();

        _internships
          ..clear()
          ..addAll(loaded);
      }
    } catch (error, stackTrace) {
      debugPrint('Failed to load internship applications: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveInternships() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(
        _internships.map((internship) => internship.toJson()).toList(),
      );
      await prefs.setString(_storageKey, encoded);
    } catch (error, stackTrace) {
      debugPrint('Failed to save internship applications: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> addInternship(Internship internship) async {
    _internships.add(internship);
    notifyListeners();
    await _saveInternships();
  }

  Future<void> updateInternship(Internship updatedInternship) async {
    final index = _internships.indexWhere(
      (i) => i.id == updatedInternship.id,
    );

    if (index != -1) {
      _internships[index] = updatedInternship;
      notifyListeners();
      await _saveInternships();
    }
  }

  Future<void> deleteInternship(String id) async {
    _internships.removeWhere((i) => i.id == id);
    notifyListeners();
    await _saveInternships();
  }

  Internship? getById(String id) {
    for (final internship in _internships) {
      if (internship.id == id) return internship;
    }
    return null;
  }

  List<Internship> search(String query) {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) return internships;

    return _internships.where((i) {
      return i.company.toLowerCase().contains(q) ||
          i.role.toLowerCase().contains(q) ||
          i.location.toLowerCase().contains(q);
    }).toList();
  }
}
