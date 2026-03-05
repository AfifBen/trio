class Goal {
  final String id;
  final String title;
  final int sessionsDone;
  final int sessionsTotal;

  const Goal({
    required this.id,
    required this.title,
    this.sessionsDone = 0,
    this.sessionsTotal = 4,
  });

  bool get completed => sessionsDone >= sessionsTotal;

  Goal copyWith({
    String? id,
    String? title,
    int? sessionsDone,
    int? sessionsTotal,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      sessionsDone: sessionsDone ?? this.sessionsDone,
      sessionsTotal: sessionsTotal ?? this.sessionsTotal,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sessionsDone': sessionsDone,
        'sessionsTotal': sessionsTotal,
      };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: json['id'] as String,
        title: json['title'] as String,
        sessionsDone: json['sessionsDone'] as int? ?? 0,
        sessionsTotal: json['sessionsTotal'] as int? ?? 4,
      );
}
