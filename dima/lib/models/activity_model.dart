class Activity {
  String name;
  String description;
  String date;

  Activity({
    required this.name,
    required this.description,
    required this.date,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'date': date,
    };
  }

  Activity.fromMap(Map<String, dynamic> data)
      : name = data['name'],
        description = data['description'],
        date = data['date'];
}