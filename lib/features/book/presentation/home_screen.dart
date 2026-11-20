import 'package:flutter/material.dart';
import '../../../core/app_settings.dart';
import '../../../core/theme.dart';
import '../data/book_repository.dart';
import '../domain/book_section.dart';
import 'reader_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'bookmarks_screen.dart';
import 'contact_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.book, required this.settings});
  final BookRepository book;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final featured = book.sections.where((s) => s.kind == 'poem' || s.kind == 'explanation' || s.kind == 'appendix').toList();
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('رسم الطالب عبد الله', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(tooltip: 'المفضلة', onPressed: () => _push(context, BookmarksScreen(book: book, settings: settings)), icon: const Icon(Icons.bookmark_outline)),
          IconButton(tooltip: 'الإعدادات', onPressed: () => _push(context, SettingsScreen(settings: settings)), icon: const Icon(Icons.tune)),
        ],
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 14),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              gradient: const LinearGradient(colors: [AppTheme.green, Color(0xFF26755B)], begin: Alignment.topRight, end: Alignment.bottomLeft),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.menu_book_rounded, color: AppTheme.gold, size: 32),
              const SizedBox(height: 14),
              Text(book.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(book.author, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 18),
              Row(children: [
                _Stat(value: '${book.sections.length}', label: 'قسماً'),
                const SizedBox(width: 20),
                _Stat(value: '${book.targetVerseCount}', label: 'بيتاً  '),
              ]),
              const SizedBox(height: 14),
              
            ]),
          ),
        )),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text('أقسام الكتاب', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        )),
        SliverPadding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 24), sliver: SliverList.builder(
          itemCount: featured.length,
          itemBuilder: (context, index) => _SectionCard(section: featured[index], onTap: () => _push(context, ReaderScreen(book: book, section: featured[index], settings: settings))),
        )),
       
        SliverPadding(padding: const EdgeInsets.fromLTRB(14, 0, 14, 30), sliver: SliverList.builder(
          itemCount: book.sections.where((s) => s.kind == 'intro' || s.kind == 'index').length,
          itemBuilder: (context, index) {
            final items = book.sections.where((s) => s.kind == 'intro' || s.kind == 'index').toList();
            final section = items[index];
            return _SectionCard(section: section, onTap: () => _push(context, ReaderScreen(book: book, section: section, settings: settings)));
          },
        )),
        ]),
      ),
      bottomNavigationBar: NavigationBar(
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: 1,
        onDestinationSelected: (index) {
          if (index == 0) {
            final introduction = book.sections.firstWhere((section) => section.id == 'book_preface');
            _push(context, ReaderScreen(book: book, section: introduction, settings: settings));
          } else if (index == 2) {
            _push(context, SearchScreen(book: book, settings: settings));
          } else if (index == 3) {
            _push(context, const ContactScreen());
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book_rounded), label: 'المقدمة'),
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.search_rounded), label: 'البحث'),
          NavigationDestination(icon: Icon(Icons.info_outline_rounded), selectedIcon: Icon(Icons.info_rounded), label: 'التواصل'),
        ],
      ),
    );
  }

  static void _push(BuildContext context, Widget page) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value, label;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
  ]);
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section, required this.onTap});
  final BookSection section;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: .12), child: Icon(_icon, color: Theme.of(context).colorScheme.primary, size: 20)),
      title: Text(section.title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_left_rounded),
    ),
  );
  IconData get _icon => switch (section.kind) {
    'explanation' => Icons.lightbulb_outline,
    'appendix' => Icons.account_tree_outlined,
    'intro' => Icons.info_outline,
    'index' => Icons.list_alt,
    _ => Icons.auto_stories_outlined,
  };
}
