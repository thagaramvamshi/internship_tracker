
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
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _headlineController = TextEditingController();
  final _collegeController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearController = TextEditingController();
  final _skillsController = TextEditingController();

  bool _isEditing = false;
  bool _isSaving = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _loadFields(context.read<ProfileProvider>());
      _initialized = true;
    }
  }

  void _loadFields(ProfileProvider profile) {
    _nameController.text = profile.name;
    _headlineController.text = profile.headline;
    _collegeController.text = profile.college;
    _courseController.text = profile.course;
    _yearController.text = profile.graduationYear;
    _skillsController.text = profile.skills.join(', ');
  }

  void _startEditing() {
    _loadFields(context.read<ProfileProvider>());
    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    _loadFields(context.read<ProfileProvider>());
    setState(() => _isEditing = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final skills = _skillsController.text
          .split(',')
          .map((skill) => skill.trim())
          .where((skill) => skill.isNotEmpty)
          .toSet()
          .toList();

      await context.read<ProfileProvider>().saveProfile(
            name: _nameController.text.trim(),
            headline: _headlineController.text.trim(),
            college: _collegeController.text.trim(),
            course: _courseController.text.trim(),
            graduationYear: _yearController.text.trim(),
            skills: skills,
          );

      if (!mounted) return;

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save profile. Try again.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _collegeController.dispose();
    _courseController.dispose();
    _yearController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 21, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 9),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _detailTile(IconData icon, String label, String value) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colors.onPrimaryContainer, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? 'Not added yet' : value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
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

    // Refresh the display when saved profile data loads.
    if (!_isEditing && _initialized) {
      if (_nameController.text != profile.name) {
        _loadFields(profile);
      }
    }

    final name = _isEditing
        ? _nameController.text.trim()
        : profile.name;
    final headline = _isEditing
        ? _headlineController.text.trim()
        : profile.headline;

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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          // Professional profile header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary,
                  colors.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.onPrimary.withValues(alpha: 0.7),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 43,
                    backgroundColor: colors.surface,
                    child: Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: colors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  name.isEmpty ? 'Your Name' : name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  headline.isEmpty
                      ? 'Add your professional headline'
                      : headline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
                if (profile.college.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 18,
                        color: colors.onPrimary,
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          profile.college,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ],
                if (!_isEditing) ...[
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: _startEditing,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.onPrimary,
                      side: BorderSide(
                        color: colors.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (_isEditing) ...[
            _sectionTitle('Edit your details', Icons.manage_accounts_outlined),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _inputField(
                        label: 'Full Name',
                        controller: _nameController,
                        icon: Icons.person_outline,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please enter your name'
                                : null,
                      ),
                      _inputField(
                        label: 'Professional Headline',
                        controller: _headlineController,
                        icon: Icons.work_outline,
                      ),
                      _inputField(
                        label: 'College / University',
                        controller: _collegeController,
                        icon: Icons.school_outlined,
                      ),
                      _inputField(
                        label: 'Course / Degree',
                        controller: _courseController,
                        icon: Icons.menu_book_outlined,
                      ),
                      _inputField(
                        label: 'Graduation Year',
                        controller: _yearController,
                        icon: Icons.calendar_month_outlined,
                        hint: 'e.g. 2028',
                      ),
                      _inputField(
                        label: 'Skills',
                        controller: _skillsController,
                        icon: Icons.code,
                        hint: 'Java, Flutter, SQL',
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isSaving ? null : _saveProfile,
                          icon: _isSaving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline),
                          label: Text(
                            _isSaving ? 'Saving...' : 'Save Changes',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: _isSaving ? null : _cancelEditing,
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            // View-only profile details
            _sectionTitle('Education', Icons.school_outlined),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _detailTile(
                      Icons.menu_book_outlined,
                      'Course / Degree',
                      profile.course,
                    ),
                    const Divider(height: 18),
                    _detailTile(
                      Icons.calendar_month_outlined,
                      'Graduation Year',
                      profile.graduationYear,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            _sectionTitle('Skills & Interests', Icons.code_rounded),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: profile.skills.isEmpty
                    ? const Text('No skills added yet. Tap Edit Profile to add some.')
                    : Wrap(
                        spacing: 9,
                        runSpacing: 9,
                        children: profile.skills
                            .map(
                              (skill) => Chip(
                                avatar: const Icon(
                                  Icons.check_circle_outline,
                                  size: 18,
                                ),
                                label: Text(skill),
                                side: BorderSide(
                                  color: colors.outlineVariant,
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ),
          ],

          const SizedBox(height: 22),

          _sectionTitle('Appearance', Icons.palette_outlined),
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
        ],
      ),
    );
  }
}
