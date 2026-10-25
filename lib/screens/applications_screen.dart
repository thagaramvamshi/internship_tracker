
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/internship.dart';
import '../providers/internship_provider.dart';
import 'add_internship_screen.dart';
import 'edit_internship_screen.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() =>
      _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  InternshipStatus? _selectedStatus;

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

  Color _statusColor(InternshipStatus status) {
    switch (status) {
      case InternshipStatus.applied:
        return Colors.blue;
      case InternshipStatus.assessment:
        return Colors.orange;
      case InternshipStatus.interview:
        return Colors.purple;
      case InternshipStatus.selected:
        return Colors.green;
      case InternshipStatus.rejected:
        return Colors.red;
    }
  }

  Future<void> _addApplication() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddInternshipScreen(),
      ),
    );
  }

  Future<void> _editApplication(Internship internship) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditInternshipScreen(
          internship: internship,
        ),
      ),
    );
  }

  Future<void> _deleteApplication(
    Internship internship,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Application?'),
        content: Text(
          'Are you sure you want to delete '
          '${internship.company}?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      context
          .read<InternshipProvider>()
          .deleteInternship(internship.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application deleted successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InternshipProvider>();

    final applications = provider.internships.where((item) {
      return _selectedStatus == null ||
          item.status == _selectedStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              '${applications.length} application'
              '${applications.length == 1 ? '' : 's'} found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 54,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedStatus == null,
                  onSelected: (_) {
                    setState(() => _selectedStatus = null);
                  },
                ),
                const SizedBox(width: 8),
                ...InternshipStatus.values.map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_statusLabel(status)),
                      selected: _selectedStatus == status,
                      selectedColor: _statusColor(status)
                          .withValues(alpha: 0.15),
                      onSelected: (_) {
                        setState(() {
                          _selectedStatus = status;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: applications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: applications.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = applications[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                child: Text(
                                  item.company.isNotEmpty
                                      ? item.company[0]
                                          .toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.company,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(item.role),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.location,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(item.status)
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _statusLabel(item.status),
                                        style: TextStyle(
                                          color: _statusColor(
                                            item.status,
                                          ),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit application',
                                    onPressed: () =>
                                        _editApplication(item),
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Delete application',
                                    onPressed: () =>
                                        _deleteApplication(item),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addApplication,
        icon: const Icon(Icons.add),
        label: const Text('Add Application'),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isFiltered = _selectedStatus != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFiltered
                  ? Icons.filter_list_off
                  : Icons.work_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isFiltered
                  ? 'No applications with this status'
                  : 'No applications yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'Try selecting another filter.'
                  : 'Add your first internship application!',
              textAlign: TextAlign.center,
            ),
            if (!isFiltered) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _addApplication,
                icon: const Icon(Icons.add),
                label: const Text('Add Application'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
