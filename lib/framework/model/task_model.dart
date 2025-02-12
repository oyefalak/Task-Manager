/// Task Model
class Task {
  final int id;
  final String title;
  final String description;
  final bool priority;
  final bool status;
  final String createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['name'],
      description: map['description'] ?? '',
      priority: map['priority'] == 1,
      status: map['status'] == 1,
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'priority': priority ? 1 : 0,
      'status': status ? 1 : 0,
      'createdAt': createdAt,
    };
  }
}
