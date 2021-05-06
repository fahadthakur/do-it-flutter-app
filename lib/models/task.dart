class Task {
  final int id;
  final String title;
  final String description;
  final String date;
  final String notify;

  Task({this.id, this.title, this.description, this.date, this.notify});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'notify': notify,
    };
  }
}
