
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/internship_provider.dart';
import 'add_internship_screen.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InternshipProvider>();
    final applications = provider.internships.reversed.toList();

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
      body: applications.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.work_outline, size: 56, color: Colors.indigo),
                    SizedBox(height: 16),
                    Text(
                      'No applications yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap Add Internship to track your first opportunity.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: applications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = applications[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.business_outlined),
                    ),
                    title: Text(
                      item.company,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${item.role}\n${item.location}'),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(item.status.name),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
