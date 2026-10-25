
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/internship.dart';
import '../providers/internship_provider.dart';
import 'add_internship_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  InternshipStatus? _selectedStatus;

  Future<void> _confirmDelete(
    BuildContext context,
    Internship internship,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete application?'),
        content: Text(
          'Remove ${internship.company} - ${internship.role}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<InternshipProvider>().deleteInternship(internship.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InternshipProvider>();

    final filtered = provider.internships.where((item) {
      return _selectedStatus == null || item.status == _selectedStatus;
    }).toList()
      ..sort((a, b) => b.appliedDate.compareTo(a.appliedDate));

    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddInternshipScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Internship'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip('All', null),
                ...InternshipStatus.values.map(
                  (status) => _filterChip(
                    _statusLabel(status),
                    status,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 56,
                            color: Colors.indigo,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No applications found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Try another status or add an internship.'),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filtered[index];

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.business_outlined),
                          ),
                          title: Text(
                            item.company,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('${item.role}\n${item.location}'),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Chip(label: Text(_statusLabel(item.status))),
                              IconButton(
                                tooltip: 'Delete application',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _confirmDelete(context, item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, InternshipStatus? status) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedStatus == status,
        onSelected: (_) => setState(() => _selectedStatus = status),
      ),
    );
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
}
