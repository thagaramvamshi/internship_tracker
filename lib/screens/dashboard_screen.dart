
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/internship_provider.dart';
import '../widgets/application_card.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InternshipProvider>();

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
            const SizedBox(height: 28),
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
              child: const Column(
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
            const SizedBox(height: 12),
            if (provider.internships.isEmpty)
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
              ...provider.internships.reversed.take(5).map(
                    (internship) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ApplicationCard(
                        internship: internship,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
