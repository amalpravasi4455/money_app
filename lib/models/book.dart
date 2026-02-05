class Book {
  final int? id;
  final String name;
  final int colorValue;
  final DateTime? lastUpdated;

  Book({
    this.id,
    required this.name,
    required this.colorValue,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'colorValue': colorValue,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      name: map['name'],
      colorValue: map['colorValue'] ?? 0xFF000000,
      lastUpdated: map['lastUpdated'] != null ? DateTime.parse(map['lastUpdated']) : null,
    );
  }
}
