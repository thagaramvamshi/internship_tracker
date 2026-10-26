
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/internship.dart';
import '../providers/internship_provider.dart';

class AddInternshipScreen extends StatefulWidget {
  const AddInternshipScreen({super.key});

  @override
  State<AddInternshipScreen> createState() => _AddInternshipScreenState();
}

class _AddInternshipScreenState extends State<AddInternshipScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _roleController = TextEditingController();
  final _locationController = TextEditingController();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _type = 'Internship';
  DateTime? _deadline;
  bool _isSaving = false;

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _locationController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );

    if (selected != null && mounted) {
      setState(() => _deadline = selected);
    }
  }

  Future<void> _saveInternship() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final internship = Internship(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      company: _companyController.text.trim(),
      role: _roleController.text.trim(),
      location: _locationController.text.trim(),
      type: _type,
      applicationUrl: _urlController.text.trim(),
      description: _descriptionController.text.trim(),
      appliedDate: DateTime.now(),
      deadline: _deadline,
    );

    context.read<InternshipProvider>().addInternship(internship);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Internship added successfully!')),
    );

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Internship')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'New opportunity',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Keep all your internship details organized.',
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 24),
              _buildField(
                controller: _companyController,
                label: 'Company name',
                icon: Icons.business_outlined,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _roleController,
                label: 'Internship role',
                icon: Icons.work_outline,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _locationController,
                label: 'Location',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'Opportunity type',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Internship',
                    child: Text('Internship'),
                  ),
                  DropdownMenuItem(
                    value: 'Remote',
                    child: Text('Remote'),
                  ),
                  DropdownMenuItem(
                    value: 'Hybrid',
                    child: Text('Hybrid'),
                  ),
                  DropdownMenuItem(
                    value: 'On-site',
                    child: Text('On-site'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _urlController,
                label: 'Application URL (optional)',
                icon: Icons.link,
                requiredField: false,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _descriptionController,
                label: 'Description (optional)',
                icon: Icons.notes_outlined,
                requiredField: false,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _selectDeadline,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  _deadline == null
                      ? 'Choose application deadline (optional)'
                      : 'Deadline: ${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                ),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveInternship,
                icon: const Icon(Icons.save_outlined),
                label: Text(
                  _isSaving ? 'Saving...' : 'Save Internship',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool requiredField = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: label.startsWith('Application URL')
          ? TextCapitalization.none
          : TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        alignLabelWithHint: maxLines > 1,
      ),
      validator: (value) {
        final text = value?.trim() ?? '';

        if (requiredField && text.isEmpty) {
          return '$label is required';
        }

        if (label.startsWith('Application URL') && text.isNotEmpty) {
          final uri = Uri.tryParse(text);

          if (uri == null ||
              !uri.hasScheme ||
              (uri.scheme != 'http' && uri.scheme != 'https') ||
              uri.host.isEmpty ||
              !uri.host.contains('.')) {
            return 'Enter a valid URL (e.g. https://company.com)';
          }
        }

        return null;
      },
    );
  }
}
