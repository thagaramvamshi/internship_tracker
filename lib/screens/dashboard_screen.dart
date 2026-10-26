
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/internship.dart';
import '../providers/internship_provider.dart';
import '../widgets/application_card.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InternshipProvider>();
    final internships = provider.internships;
    final totalApplications = internships.length;
final selectionRate = totalApplications == 0
    ? 0.0
    : provider.selectedCount / totalApplications * 100;

final statusBreakdown = <Map<String, dynamic>>[
  {
    'label': 'Applied',
    'count': provider.appliedCount,
    'color': Colors.blue,
  },
  {
    'label': 'Assessment',
    'count': provider.assessmentCount,
    'color': Colors.orange,
  },
  {
    'label': 'Interview',
    'count': provider.interviewCount,
    'color': Colors.purple,
  },
  {
    'label': 'Selected',
    'count': provider.selectedCount,
    'color': Colors.green,
  },
  {
    'label': 'Rejected',
    'count': provider.rejectedCount,
    'color': Colors.red,
  },
];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextWeek = today.add(const Duration(days: 7));

    final upcomingDeadlines = internships.where((internship) {
      final deadline = internship.deadline;
      if (deadline == null ||
          internship.status == InternshipStatus.selected ||
          internship.status == InternshipStatus.rejected) {
        return false;
      }

      final date = DateTime(deadline.year, deadline.month, deadline.day);
      return !date.isBefore(today) && !date.isAfter(nextWeek);
    }).toList()
      ..sort((a, b) => a.deadline!.compareTo(b.deadline!));

    final overdueDeadlines = internships.where((internship) {
      final deadline = internship.deadline;
      if (deadline == null ||
          internship.status == InternshipStatus.selected ||
          internship.status == InternshipStatus.rejected) {
        return false;
      }

      final date = DateTime(deadline.year, deadline.month, deadline.day);
      return date.isBefore(today);
    }).toList()
      ..sort((a, b) => a.deadline!.compareTo(b.deadline!));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Internship Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Profile',
            icon: const CircleAvatar(
              radius: 17,
              child: Icon(Icons.person_outline, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Your career journey starts here.',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 15,
              ),
            ),
            
            const SizedBox(height: 24),

            const Text(
              'Application Insights',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selection Rate',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${selectionRate.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '$totalApplications total applications',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: selectionRate / 100,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Status Breakdown',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    if (totalApplications == 0)
                      const Text(
                        'Add applications to see your progress here.',
                      )
                    else
                      ...statusBreakdown.map((item) {
                        final count = item['count'] as int;
                        final color = item['color'] as Color;
                        final label = item['label'] as String;
                        final progress = count / totalApplications;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(label)),
                                  Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 7,
                                color: color,
                                backgroundColor:
                                    Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Deadline overview

            const Text(
              'Application Overview',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 600 ? 3 : 2;
                final cardWidth =
                    (constraints.maxWidth - (columns - 1) * 12) /
                        columns;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Total',
                        count: provider.totalCount,
                        icon: Icons.work_outline,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Applied',
                        count: provider.appliedCount,
                        icon: Icons.send_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Interviews',
                        count: provider.interviewCount,
                        icon: Icons.groups_outlined,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Assessments',
                        count: provider.assessmentCount,
                        icon: Icons.assignment_outlined,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Selected',
                        count: provider.selectedCount,
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: StatCard(
                        title: 'Rejected',
                        count: provider.rejectedCount,
                        icon: Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Deadline overview
            const Text(
              'Deadline Overview',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DeadlineSummaryCard(
                    title: 'Upcoming (7 days)',
                    count: upcomingDeadlines.length,
                    icon: Icons.event_available,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DeadlineSummaryCard(
                    title: 'Overdue',
                    count: overdueDeadlines.length,
                    icon: Icons.warning_amber_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (overdueDeadlines.isNotEmpty) ...[
              const Text(
                'Overdue Applications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              ...overdueDeadlines.map(
                (internship) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ApplicationCard(internship: internship),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (upcomingDeadlines.isNotEmpty) ...[
              const Text(
                'Upcoming Deadlines',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF166534),
                ),
              ),
              const SizedBox(height: 10),
              ...upcomingDeadlines.map(
                (internship) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ApplicationCard(internship: internship),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF7C3AED),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.rocket_launch,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Keep moving forward!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Track every application and take the next step '
                    'toward your dream internship.',
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Applications',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/career-tips');
                    },
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('Explore Career Tips'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                    ),
                  ),

            const SizedBox(height: 12),
            if (internships.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.work_history_outlined,
                        size: 44,
                        color: Color(0xFF94A3B8),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No applications yet',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Your internship applications will appear here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...internships.reversed.take(5).map(
                    (internship) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ApplicationCard(internship: internship),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineSummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _DeadlineSummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 10),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
