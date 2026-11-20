import 'package:flutter/material.dart';
import '../data/book_repository.dart';
import '../../../core/app_settings.dart';
import 'reader_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.book, required this.settings});
  final BookRepository book;
  final AppSettings settings;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  String query = '';
  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final q = query.trim();
    final sections = widget.book.searchSectionTitles(q);
    final textMatches = widget.book.searchSectionText(q);
    final verses = widget.book.search(q);
    return Scaffold(
      appBar: AppBar(title: const Text('البحث في الكتاب')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 6, 16, 12), child: SearchBar(
          controller: controller,
          hintText: 'اكتب كلمة أو جزءاً من عبارة',
          leading: const Icon(Icons.search),
          trailing: [if (controller.text.isNotEmpty) IconButton(onPressed: () { controller.clear(); setState(() => query = ''); }, icon: const Icon(Icons.close))],
          onChanged: (value) => setState(() => query = value),
        )),
        Expanded(child: q.isEmpty
            ? const Center(child: Text('ابحث في عناوين الأبواب ونصوصها والأبيات'))
            : ListView(children: [
                if (sections.isNotEmpty) ...[
                  const _Header('الأبواب'),
                  ...sections.map((s) => ListTile(title: Text(s.title), trailing: const Icon(Icons.chevron_left), onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ReaderScreen(book: widget.book, section: s, settings: widget.settings)));
                  })),
                ],
                if (textMatches.isNotEmpty) ...[
                  const _Header('نتائج في نصوص الأبواب'),
                  ...textMatches.map((match) => ListTile(
                    leading: const Icon(Icons.menu_book_outlined),
                    title: Text(match.text, maxLines: 2, overflow: TextOverflow.ellipsis, textDirection: TextDirection.rtl),
                    subtitle: Text(match.verseNumber == null
                        ? match.section.title
                        : '${match.section.title} • البيت ${match.verseNumber}',
                      textDirection: TextDirection.rtl),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => ReaderScreen(book: widget.book, section: match.section, settings: widget.settings),
                    )),
                  )),
                ],
                if (verses.isNotEmpty) ...[
                  const _Header('الأبيات'),
                  ...verses.map((v) => ListTile(
                    leading: CircleAvatar(child: Text('${v.number}')),
                    title: Text(v.text),
                    subtitle: Text(widget.book.sections.firstWhere((s) => s.id == v.sectionId).title),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => ReaderScreen(
                        book: widget.book,
                        section: widget.book.sections.firstWhere((s) => s.id == v.sectionId),
                        settings: widget.settings,
                        targetVerseNumber: v.number,
                      ),
                    )),
                  )),
                ],
                if (sections.isEmpty && textMatches.isEmpty && verses.isEmpty) const Padding(padding: EdgeInsets.all(28), child: Center(child: Text('لا توجد نتائج مطابقة.'))),
              ])),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(18, 12, 18, 4), child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)));
}
