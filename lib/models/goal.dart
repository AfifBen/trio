class Goal {
  final String id;
  final String title;
  final String categoryType; // project | habit | path | work
  final String categoryItem;
  final int sessionsDone;
  final int sessionsTotal;

  const Goal({
    required this.id,
    required this.title,
    required this.categoryType,
    required this.categoryItem,
    this.sessionsDone = 0,
    this.sessionsTotal = 4,
  });

  bool get completed => sessionsDone >= sessionsTotal;

  Goal copyWith({
    String? id,
    String? title,
    String? categoryType,
    String? categoryItem,
    int? sessionsDone,
    int? sessionsTotal,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryType: categoryType ?? this.categoryType,
      categoryItem: categoryItem ?? this.categoryItem,
      sessionsDone: sessionsDone ?? this.sessionsDone,
      sessionsTotal: sessionsTotal ?? this.sessionsTotal,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'categoryType': categoryType,
        'categoryItem': categoryItem,
        'sessionsDone': sessionsDone,
        'sessionsTotal': sessionsTotal,
      };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
        id: json['id'] as String,
        title: json['title'] as String,
        categoryType: json['categoryType'] as String? ?? 'work',
        categoryItem: json['categoryItem'] as String? ?? '',
        sessionsDone: json['sessionsDone'] as int? ?? 0,
        sessionsTotal: json['sessionsTotal'] as int? ?? 4,
      );
}
