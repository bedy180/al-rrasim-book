import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/app_settings.dart';
import '../../../core/theme.dart';
import '../data/book_repository.dart';
import '../domain/book_section.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.book, required this.section, required this.settings, this.targetVerseNumber});
  final BookRepository book;
  final BookSection section;
  final AppSettings settings;
  final int? targetVerseNumber;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _targetVerseKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget());
  }

  void _scrollToTarget() {
    if (widget.targetVerseNumber == null) return;
    final targetContext = _targetVerseKey.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      alignment: .2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final verses = widget.book.versesFor(widget.section.id);
    final versesByNumber = {for (final verse in verses) verse.number: verse};
    final sectionContent = widget.book.contentFor(widget.section.id)?.trim();
    final sectionIndex = widget.book.sections.indexWhere((item) => item.id == widget.section.id);
    final chapterColor = _chapterColors[(sectionIndex < 0 ? 0 : sectionIndex) % _chapterColors.length];
    return Scaffold(
      appBar: AppBar(title: Text(widget.section.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _ChapterHeader(
            title: widget.section.title,
            color: chapterColor,
            eyebrow: widget.section.kind == 'intro' ? 'من الكتاب' : 'من أبواب النظم',
          ),
          const SizedBox(height: 18),
          if (sectionContent?.isNotEmpty == true)
            ...sectionContent!.split('\n').where((line) => line.trim().isNotEmpty).map((rawLine) {
              final line = rawLine.trim();
              final number = BookRepository.verseNumberFromLine(line);
              final verse = number == null ? null : versesByNumber[number];
              if (verse != null) {
                return _VerseCard(
                  key: verse.number == widget.targetVerseNumber ? _targetVerseKey : null,
                  verse: verse,
                  settings: widget.settings,
                  highlighted: verse.number == widget.targetVerseNumber,
                );
              }
              final isHeading = line.startsWith('باب ') || line.startsWith('مقدمة') || line.startsWith('شرح قاعدة');
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 12),
                child: SelectableText(
                  line,
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.rtl,
                  style: isHeading
                      ? Theme.of(context).textTheme.titleMedium?.copyWith(color: chapterColor, fontWeight: FontWeight.bold)
                      : Theme.of(context).textTheme.bodyLarge?.copyWith(height: 2.05),
                ),
              );
            })
          else if (verses.isNotEmpty)
            ...verses.map((verse) => _VerseCard(
              key: verse.number == widget.targetVerseNumber ? _targetVerseKey : null,
              verse: verse,
              settings: widget.settings,
              highlighted: verse.number == widget.targetVerseNumber,
            ))
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    Icon(Icons.edit_note_rounded, size: 48, color: chapterColor),
                    const SizedBox(height: 12),
                    Text('هذا القسم ضمن الفهرس', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    const Text('سيظهر النص هنا بعد إدخال الأبيات ومراجعتها على النسخة المحققة.', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

const _chapterColors = <Color>[
  Color(0xFF176B56),
  Color(0xFF9A5A18),
  Color(0xFF455C9A),
  Color(0xFF8C456C),
  Color(0xFF44705D),
  Color(0xFF8A6033),
  Color(0xFF5B5795),
  Color(0xFF3F7582),
];

class _ChapterHeader extends StatelessWidget {
  const _ChapterHeader({required this.title, required this.color, required this.eyebrow});
  final String title;
  final Color color;
  final String eyebrow;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, Color.lerp(color, Colors.black, .24)!],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Stack(
            children: [
              Positioned(left: -24, top: -42, child: Icon(Icons.auto_stories_rounded, size: 150, color: Colors.white.withValues(alpha: .08))),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.menu_book_rounded, color: Color(0xFFFFD98A), size: 22),
                      const SizedBox(width: 9),
                      Text(eyebrow, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white.withValues(alpha: .84))),
                    ]),
                    const SizedBox(height: 15),
                    Text(title, textDirection: TextDirection.rtl,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, height: 1.45)),
                    const SizedBox(height: 12),
                    Container(width: 46, height: 3, decoration: BoxDecoration(color: const Color(0xFFFFD98A), borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _VerseCard extends StatelessWidget {
  const _VerseCard({super.key, required this.verse, required this.settings, this.highlighted = false});
  final Verse verse;
  final AppSettings settings;
  final bool highlighted;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    color: highlighted ? Theme.of(context).colorScheme.primaryContainer : null,
    shape: highlighted
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
          )
        : null,
    child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        CircleAvatar(radius: 16, child: Text('${verse.number}', style: const TextStyle(fontSize: 11))),
        const Spacer(),
        IconButton(tooltip: 'نسخ البيت', onPressed: () => Clipboard.setData(ClipboardData(text: verse.text)), icon: const Icon(Icons.copy_outlined)),
        IconButton(tooltip: 'مشاركة البيت', onPressed: () => Share.share(verse.text), icon: const Icon(Icons.share_outlined)),
        IconButton(
          tooltip: 'المفضلة',
          onPressed: () => settings.toggleBookmark(verse.number),
          icon: AnimatedBuilder(
            animation: settings,
            builder: (context, _) => Icon(
              settings.bookmarks.contains(verse.number) ? Icons.bookmark : Icons.bookmark_border,
              color: AppTheme.gold,
            ),
          ),
        ),
      ]),
      Text(verse.text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 2, fontFamily: 'serif')),
      if (verse.explanation?.isNotEmpty ?? false) ...[const Divider(height: 24), Text(verse.explanation!)],
    ])),
  );
}
