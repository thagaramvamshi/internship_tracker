
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/internship.dart';
import '../providers/internship_provider.dart';

class EditInternshipScreen extends StatefulWidget {
  final Internship internship;

  const EditInternshipScreen({
    super.key,
    required this.internship,
  });

  @override
  State<EditInternshipScreen> createState() =>
      _EditInternshipScreenState();
}

class _EditInternshipScreenState
    extends State<EditInternshipScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _companyController;
  late final TextEditingController _roleController;
  late final TextEditingController _locationController;
  late final TextEditingController _urlController;
  late final TextEditingController _descriptionController;

  late String _type;
  late InternshipStatus _status;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final item = widget.internship;

    _companyController = TextEditingController(text: item.company);
    _roleController = TextEditingController(text: item.role);
    _locationController = TextEditingController(text: item.location);
    _urlController = TextEditingController(text: item.applicationUrl);
    _descriptionController =
        TextEditingController(text: item.description);

    _type = item.type;
    _status = item.status;
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _locationController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updated = widget.internship.copyWith(
      company: _companyController.text.trim(),
      role: _roleController.text.trim(),
      location: _locationController.text.trim(),
      type: _type,
      applicationUrl: _urlController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _status,
    );

    context.read<InternshipProvider>().updateInternship(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application updated successfully')),
    );

    Navigator.pop(context);
  }

  String _statusLabel(InternshipStatus status) {
    switch (status) {
      case InternshipStatus.applied:
        return 'Applied';
      case InternshipStatus.assessment:
        return 'Assessment';
      case InternshipStatus.interview:
        return 'Interview';
      case InternshipStatus.selected:
        return 'Selected';
      case InternshipStatus.rejected:
        return 'Rejected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Application')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter the company name'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: 'Job role',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter the job role'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter the location'
                        : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'Application type',
                  border: OutlineInputBorder(),
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
              DropdownButtonFormField<InternshipStatus>(
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Application status',
                  border: OutlineInputBorder(),
                ),
                items: InternshipStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_statusLabel(status)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Application URL (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveChanges,
                icon: const Icon(Icons.save_outlined),
                label: Text(
                  _isSaving ? 'Saving...' : 'Save Changes',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
