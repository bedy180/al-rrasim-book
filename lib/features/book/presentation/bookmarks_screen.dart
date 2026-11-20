import 'package:flutter/material.dart';
import '../../../core/app_settings.dart';
import '../data/book_repository.dart';
import 'reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key, required this.book, required this.settings});
  final BookRepository book;
  final AppSettings settings;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('المفضلة')),
    body: AnimatedBuilder(animation: settings, builder: (context, _) {
      final saved = book.verses.where((v) => settings.bookmarks.contains(v.number)).toList();
      if (saved.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(28), child: Text('لم تحفظ أبياتاً بعد. يمكنك حفظ أي بيت من شاشة القراءة.')));
      return ListView.builder(padding: const EdgeInsets.all(12), itemCount: saved.length, itemBuilder: (context, index) {
        final verse = saved[index];
        final section = book.sections.firstWhere((s) => s.id == verse.sectionId);
        return Card(child: ListTile(
          leading: CircleAvatar(child: Text('${verse.number}')),
          title: Text(verse.text, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(section.title),
          trailing: IconButton(icon: const Icon(Icons.bookmark_remove_outlined), onPressed: () => settings.toggleBookmark(verse.number)),
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ReaderScreen(book: book, section: section, settings: settings))),
        ));
      });
    }),
  );
}
