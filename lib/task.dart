class Task {
  int? id;
  String name;
  String description;
  DateTime date;
  bool isCompleted;
  bool isRepeated;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.date,
    this.isCompleted = false,
    this.isRepeated = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'isRepeated': isRepeated ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] == 1,
      isRepeated: map['isRepeated'] == 1,
    );
  }
}
