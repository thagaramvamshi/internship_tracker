
import 'package:flutter/material.dart';

import '../models/internship.dart';
import '../widgets/status_badge.dart';

class InternshipDetailsScreen extends StatelessWidget {
  final Internship internship;

  const InternshipDetailsScreen({
    super.key,
    required this.internship,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 36,
            child: Text(
              internship.company.isNotEmpty
                  ? internship.company[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            internship.company,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            internship.role,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Center(
            child: StatusBadge(status: internship.status),
          ),
          const SizedBox(height: 24),
          _detailTile(
            context,
            Icons.location_on_outlined,
            'Location',
            internship.location,
          ),
          _detailTile(
            context,
            Icons.work_outline,
            'Application Type',
            internship.type,
          ),
          _detailTile(
            context,
            Icons.calendar_today_outlined,
            'Applied Date',
            _formatDate(internship.appliedDate),
          ),
          if (internship.deadline != null)
            _detailTile(
              context,
              Icons.event_outlined,
              'Application Deadline',
              _formatDate(internship.deadline!),
            ),
          if (internship.interviewDate != null)
            _detailTile(
              context,
              Icons.groups_outlined,
              'Interview Date',
              _formatDate(internship.interviewDate!),
            ),
          if (internship.applicationUrl.isNotEmpty)
            _detailTile(
              context,
              Icons.link,
              'Application URL',
              internship.applicationUrl,
            ),
          if (internship.description.isNotEmpty)
            _detailTile(
              context,
              Icons.description_outlined,
              'Description',
              internship.description,
            ),
        ],
      ),
    );
  }

  Widget _detailTile(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: SelectableText(value),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}
