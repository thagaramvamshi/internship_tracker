
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _headlineController = TextEditingController();
  final _collegeController = TextEditingController();
  final _courseController = TextEditingController();
  final _graduationController = TextEditingController();
  final _skillsController = TextEditingController();

  bool _isEditing = false;
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final profile = context.read<ProfileProvider>();
      _nameController.text = profile.name;
      _headlineController.text = profile.headline;
      _collegeController.text = profile.college;
      _courseController.text = profile.course;
      _graduationController.text = profile.graduationYear;
      _skillsController.text = profile.skills.join(', ');
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _collegeController.dispose();
    _courseController.dispose();
    _graduationController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _startEditing() {
    final profile = context.read<ProfileProvider>();

    _nameController.text = profile.name;
    _headlineController.text = profile.headline;
    _collegeController.text = profile.college;
    _courseController.text = profile.course;
    _graduationController.text = profile.graduationYear;
    _skillsController.text = profile.skills.join(', ');

    setState(() => _isEditing = true);
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final skills = _skillsController.text
          .split(',')
          .map((skill) => skill.trim())
          .where((skill) => skill.isNotEmpty)
          .toSet()
          .toList();

      await context.read<ProfileProvider>().saveProfile(
            name: name,
            headline: _headlineController.text.trim(),
            college: _collegeController.text.trim(),
            course: _courseController.text.trim(),
            graduationYear: _graduationController.text.trim(),
            skills: skills,
          );

      if (!mounted) return;

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save profile. Please try again.'),
        ),
      );
    }
  }

  Widget _profileField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        readOnly: !_isEditing,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Keep the fields synchronized when saved profile data loads.
    if (!_isEditing && _initialized) {
      if (_nameController.text != profile.name) {
        _nameController.text = profile.name;
      }
      if (_headlineController.text != profile.headline) {
        _headlineController.text = profile.headline;
      }
      if (_collegeController.text != profile.college) {
        _collegeController.text = profile.college;
      }
      if (_courseController.text != profile.course) {
        _courseController.text = profile.course;
      }
      if (_graduationController.text != profile.graduationYear) {
        _graduationController.text = profile.graduationYear;
      }
      if (_skillsController.text != profile.skills.join(', ')) {
        _skillsController.text = profile.skills.join(', ');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              tooltip: 'Edit profile',
              onPressed: _startEditing,
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: colors.primary,
                  child: Icon(
                    Icons.person,
                    size: 46,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _nameController.text.trim().isEmpty
                      ? 'Student Name'
                      : _nameController.text,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _headlineController.text,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 18,
                      color: colors.onPrimaryContainer,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _collegeController.text.trim().isEmpty
                            ? 'Add your college'
                            : _collegeController.text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Personal Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _profileField(
            label: 'Full Name',
            controller: _nameController,
            icon: Icons.person_outline,
          ),
          _profileField(
            label: 'Professional Headline',
            controller: _headlineController,
            icon: Icons.work_outline,
          ),
          _profileField(
            label: 'College / University',
            controller: _collegeController,
            icon: Icons.school_outlined,
          ),
          _profileField(
            label: 'Course / Degree',
            controller: _courseController,
            icon: Icons.menu_book_outlined,
          ),
          _profileField(
            label: 'Graduation Year',
            controller: _graduationController,
            icon: Icons.calendar_month_outlined,
            hint: 'e.g. 2028',
          ),
          const SizedBox(height: 12),
          Text(
            'Skills & Interests',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (_isEditing)
            _profileField(
              label: 'Skills',
              controller: _skillsController,
              icon: Icons.code,
              hint: 'Enter skills separated by commas',
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.skills.isEmpty
                      ? [const Text('No skills added yet')]
                      : profile.skills
                          .map(
                            (skill) => Chip(
                              avatar: const Icon(
                                Icons.check_circle_outline,
                                size: 18,
                              ),
                              label: Text(skill),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          if (_isEditing) ...[
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_isSaving ? 'Saving...' : 'Save Profile'),
            ),
            TextButton(
              onPressed: _isSaving
                  ? null
                  : () {
                      setState(() => _isEditing = false);
                      _startEditing();
                    },
              child: const Text('Cancel'),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Appearance',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: Icon(
                themeProvider.isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
              title: const Text('Dark Mode'),
              subtitle: Text(
                themeProvider.isDarkMode
                    ? 'Dark theme enabled'
                    : 'Light theme enabled',
              ),
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
