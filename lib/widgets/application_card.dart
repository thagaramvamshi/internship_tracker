
import 'package:flutter/material.dart';

import '../models/internship.dart';
import 'status_badge.dart';

class ApplicationCard extends StatelessWidget {
  final Internship internship;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ApplicationCard({
    super.key,
    required this.internship,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final deadline = internship.deadline;
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = deadline == null
        ? null
        : DateTime(deadline.year, deadline.month, deadline.day);

    final isOverdue =
        deadlineDay != null && deadlineDay.isBefore(today);
    final isDueToday =
        deadlineDay != null && deadlineDay == today;

    final deadlineColor = isOverdue
        ? Colors.red
        : isDueToday
            ? Colors.orange
            : Colors.green;

    final deadlineLabel = isOverdue
        ? 'Overdue'
        : isDueToday
            ? 'Due today'
            : 'Upcoming';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  internship.company.isNotEmpty
                      ? internship.company[0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      internship.company,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(internship.role),
                    const SizedBox(height: 4),
                    Text(
                      internship.location,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    StatusBadge(status: internship.status),
                    if (deadline != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 16,
                            color: deadlineColor,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Deadline: ${deadline.day.toString().padLeft(2, '0')}/'
                              '${deadline.month.toString().padLeft(2, '0')}/'
                              '${deadline.year}',
                              style: TextStyle(
                                fontSize: 12,
                                color: deadlineColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            deadlineLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: deadlineColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  tooltip: 'Application actions',
                  onSelected: (action) {
                    if (action == 'edit') onEdit?.call();
                    if (action == 'delete') onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
