class Task {
  String id;
  String title;
  String description;
  bool isDone;
  int priority;

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.isDone,
      required this.priority});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_done': isDone ? 1 : 0,
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['is_done'] == 0 ? false : true,
      priority: map['priority'],
    );
  }
}
