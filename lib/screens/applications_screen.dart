
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/internship.dart';
import '../providers/internship_provider.dart';
import '../widgets/application_card.dart';
import 'add_internship_screen.dart';
import 'edit_internship_screen.dart';
import 'internship_details_screen.dart';


enum ApplicationSort {
  newest,
  oldest,
  companyAZ,
}

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() =>
      _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  InternshipStatus? _selectedStatus;
  ApplicationSort _sort = ApplicationSort.newest;
  String _searchQuery = '';

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

  Future<void> _viewDetails(Internship internship) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InternshipDetailsScreen(
          internship: internship,
        ),
      ),
    );
  }

  Future<void> _deleteApplication(Internship internship) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Application?'),
        content: Text(
          'Are you sure you want to delete ${internship.company}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
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
      final matchesStatus =
          _selectedStatus == null || item.status == _selectedStatus;

      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
    item.company.toLowerCase().contains(query) ||
    item.role.toLowerCase().contains(query) ||
    item.location.toLowerCase().contains(query) ||
    item.type.toLowerCase().contains(query);

      return matchesStatus && matchesSearch;
    }).toList();

    switch (_sort) {
      case ApplicationSort.newest:
        applications.sort(
          (a, b) => b.appliedDate.compareTo(a.appliedDate),
        );
      case ApplicationSort.oldest:
        applications.sort(
          (a, b) => a.appliedDate.compareTo(b.appliedDate),
        );
      case ApplicationSort.companyAZ:
        applications.sort(
          (a, b) => a.company.toLowerCase().compareTo(
                b.company.toLowerCase(),
              ),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        actions: [
          
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: 'Search company, role or location',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${applications.length} application'
                    '${applications.length == 1 ? '' : 's'} found',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<ApplicationSort>(
                  value: _sort,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(
                      value: ApplicationSort.newest,
                      child: Text('Newest first'),
                    ),
                    DropdownMenuItem(
                      value: ApplicationSort.oldest,
                      child: Text('Oldest first'),
                    ),
                    DropdownMenuItem(
                      value: ApplicationSort.companyAZ,
                      child: Text('Company A–Z'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _sort = value);
                    }
                  },
                ),
              ],
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

          if (_selectedStatus != null || _searchQuery.trim().isNotEmpty)
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        const Icon(Icons.filter_alt_outlined, size: 18),
        const SizedBox(width: 6),
        const Expanded(
          child: Text('Filters active'),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _selectedStatus = null;
              _searchQuery = '';
            });
          },
          icon: const Icon(Icons.clear),
          label: const Text('Clear filters'),
        ),
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

                      return ApplicationCard(
                        internship: item,
                        onTap: () => _viewDetails(item),
                        onEdit: () => _editApplication(item),
                        onDelete: () => _deleteApplication(item),
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
    final isFiltered =
        _selectedStatus != null || _searchQuery.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFiltered ? Icons.search_off : Icons.work_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isFiltered
                  ? 'No matching applications'
                  : 'No applications yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'Try another search or status filter.'
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
