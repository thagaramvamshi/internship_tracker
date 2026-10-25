
enum InternshipStatus {
  applied,
  assessment,
  interview,
  selected,
  rejected,
}

class Internship {
  final String id;
  final String company;
  final String role;
  final String location;
  final String type;
  final String description;
  final String applicationUrl;
  final DateTime appliedDate;
  final DateTime? deadline;
  final DateTime? interviewDate;
  final InternshipStatus status;

  const Internship({
    required this.id,
    required this.company,
    required this.role,
    required this.location,
    required this.type,
    this.description = '',
    this.applicationUrl = '',
    required this.appliedDate,
    this.deadline,
    this.interviewDate,
    this.status = InternshipStatus.applied,
  });

  Internship copyWith({
    String? company,
    String? role,
    String? location,
    String? type,
    String? description,
    String? applicationUrl,
    DateTime? appliedDate,
    DateTime? deadline,
    DateTime? interviewDate,
    InternshipStatus? status,
  }) {
    return Internship(
      id: id,
      company: company ?? this.company,
      role: role ?? this.role,
      location: location ?? this.location,
      type: type ?? this.type,
      description: description ?? this.description,
      applicationUrl: applicationUrl ?? this.applicationUrl,
      appliedDate: appliedDate ?? this.appliedDate,
      deadline: deadline ?? this.deadline,
      interviewDate: interviewDate ?? this.interviewDate,
      status: status ?? this.status,
    );
  }
}
