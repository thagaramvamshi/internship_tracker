
import 'package:flutter/material.dart';
import '../models/internship.dart';

class StatusBadge extends StatelessWidget {
  final InternshipStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  String get _label {
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

  Color get _color {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
