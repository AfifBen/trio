class Goal {
  final String title;
  final int sessionsDone;
  final int sessionsTotal;
  final bool completed;

  const Goal({
    required this.title,
    this.sessionsDone = 0,
    this.sessionsTotal = 4,
    this.completed = false,
  });
}
