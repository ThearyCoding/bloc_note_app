class Note {
  final int? id;
  final String content;
  final DateTime createdAt;

  Note({
    this.id,
    required this.content,
    required this.createdAt,
  });

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id, // SQLite will auto-assign id if it's null
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Extract a Note object from a Map object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Note copyWith({
    int? id,
    String? content,
    DateTime? createdAt,
  }) {
    return Note(
        id: id ?? this.id,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt);
  }
}
