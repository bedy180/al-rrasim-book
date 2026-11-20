import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/book_section.dart';

class BookRepository {
  BookRepository._(this.metadata, this.sections, this.verses, this.sectionContent);
  final Map<String, dynamic> metadata;
  final List<BookSection> sections;
  final List<Verse> verses;
  final Map<String, String> sectionContent;

  String get title => metadata['shortTitle'] as String;
  int get targetVerseCount => metadata['poemVerseCount'] as int;
  String get author => metadata['author'] as String;
  bool get hasVerifiedVerses => verses.isNotEmpty;

  static Future<BookRepository> load() async {
    final raw = await rootBundle.loadString('assets/data/book.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final preface = await rootBundle.loadString('assets/data/preface.txt');
    final sections = (json['sections'] as List)
        .map((e) => BookSection.fromJson(e as Map<String, dynamic>))
        .toList();
    final chapterContent = <String, String>{};
    for (final section in sections) {
      chapterContent[section.id] = await rootBundle.loadString(
        'assets/data/chapters/${section.id}.txt',
      );
    }
    final versesByKey = <String, Verse>{};
    for (final verse in (json['verses'] as List)
        .map((e) => Verse.fromJson(e as Map<String, dynamic>))) {
      versesByKey['${verse.sectionId}:${verse.number}'] = verse;
    }
    for (final section in sections) {
      if (section.kind != 'poem' && section.kind != 'explanation') continue;
      for (final line in chapterContent[section.id]!.split('\n')) {
        final number = verseNumberFromLine(line);
        final match = _numberedVerse.firstMatch(line.trim());
        if (number == null || match == null) continue;
        versesByKey.putIfAbsent(
          '${section.id}:$number',
          () => Verse(number: number, sectionId: section.id, text: match.group(2)!.trim()),
        );
      }
    }
    return BookRepository._(
      json,
      sections,
      versesByKey.values.toList()..sort((a, b) => a.number.compareTo(b.number)),
      {'preface': preface, ...chapterContent},
    );
  }

  String? contentFor(String sectionId) => sectionContent[sectionId];
  List<Verse> versesFor(String sectionId) => verses.where((v) => v.sectionId == sectionId).toList();

  static int? verseNumberFromLine(String line) {
    final digits = _numberedVerse.firstMatch(line.trim())?.group(1);
    if (digits == null) return null;
    final asciiDigits = digits.replaceAllMapped(RegExp(r'[٠-٩۰-۹]'), (match) {
      final code = match.group(0)!.codeUnitAt(0);
      final value = code >= 0x06F0 ? code - 0x06F0 : code - 0x0660;
      return '$value';
    });
    return int.tryParse(asciiDigits);
  }

  List<BookSection> searchSectionTitles(String query) {
    final q = _normalizeSearchText(query);
    if (q.isEmpty) return [];
    return sections.where((section) => _normalizeSearchText(section.title).contains(q)).toList();
  }

  List<SectionTextMatch> searchSectionText(String query) {
    final q = _normalizeSearchText(query);
    if (q.isEmpty) return [];
    final matches = <SectionTextMatch>[];
    for (final section in sections) {
      final content = sectionContent[section.id];
      if (content == null) continue;
      for (final rawLine in content.split('\n')) {
        final line = rawLine.trim();
        if (line.isEmpty || BookRepository.verseNumberFromLine(line) != null || !_normalizeSearchText(line).contains(q)) continue;
        final number = BookRepository.verseNumberFromLine(line);
        matches.add(SectionTextMatch(
          section: section,
          text: line,
          verseNumber: number,
        ));
      }
    }
    return matches;
  }

  List<Verse> search(String query) {
    final q = _normalizeSearchText(query);
    if (q.isEmpty) return [];
    return verses.where((v) =>
      _normalizeSearchText(v.text).contains(q) ||
      _normalizeSearchText(v.explanation ?? '').contains(q),
    ).toList();
  }
}

class SectionTextMatch {
  const SectionTextMatch({required this.section, required this.text, this.verseNumber});
  final BookSection section;
  final String text;
  final int? verseNumber;
}

String _normalizeSearchText(String text) => text
    .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
    .replaceAll('\u0640', '')
    .replaceAll(RegExp(r'[أإآٱ]'), 'ا')
    .replaceAll('ى', 'ي')
    .toLowerCase()
    .trim();

final _numberedVerse = RegExp(r'^\s*([0-9٠-٩۰-۹]+)\s*[-–]\s*(.+)\s*$');
