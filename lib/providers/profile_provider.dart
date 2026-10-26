
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  static const String _storageKey = 'student_profile';

  String name = 'Student Name';
  String headline = 'Aspiring Software Developer';
  String college = '';
  String course = 'Computer Science';
  String graduationYear = '';
  List<String> skills = [
    'Flutter',
    'Java',
    'Problem Solving',
  ];

  ProfileProvider() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final savedProfile = prefs.getString(_storageKey);

    if (savedProfile != null) {
      final data = jsonDecode(savedProfile) as Map<String, dynamic>;

      name = data['name'] as String? ?? name;
      headline = data['headline'] as String? ?? headline;
      college = data['college'] as String? ?? college;
      course = data['course'] as String? ?? course;
      graduationYear =
          data['graduationYear'] as String? ?? graduationYear;

      final savedSkills = data['skills'];
      if (savedSkills is List) {
        skills = savedSkills.map((skill) => skill.toString()).toList();
      }

      notifyListeners();
    }
  }

  Future<void> saveProfile({
    required String name,
    required String headline,
    required String college,
    required String course,
    required String graduationYear,
    required List<String> skills,
  }) async {
    this.name = name;
    this.headline = headline;
    this.college = college;
    this.course = course;
    this.graduationYear = graduationYear;
    this.skills = List<String>.from(skills);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _storageKey,
      jsonEncode({
        'name': this.name,
        'headline': this.headline,
        'college': this.college,
        'course': this.course,
        'graduationYear': this.graduationYear,
        'skills': this.skills,
      }),
    );

    notifyListeners();
  }
}
