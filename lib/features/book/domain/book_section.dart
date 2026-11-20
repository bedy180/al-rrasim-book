class BookSection {
  const BookSection({required this.id, required this.title, required this.kind});
  final String id;
  final String title;
  final String kind;
  factory BookSection.fromJson(Map<String, dynamic> json) => BookSection(
        id: json['id'] as String,
        title: json['title'] as String,
        kind: json['kind'] as String,
      );
}

class Verse {
  const Verse({required this.number, required this.sectionId, required this.text, this.explanation});
  final int number;
  final String sectionId;
  final String text;
  final String? explanation;
  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        number: json['number'] as int,
        sectionId: json['sectionId'] as String,
        text: json['text'] as String,
        explanation: json['explanation'] as String?,
      );
}
