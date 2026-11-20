import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_settings.dart';
import 'core/app_background.dart';
import 'core/theme.dart';
import 'features/book/data/book_repository.dart';
import 'features/book/presentation/home_screen.dart';
import 'features/book/presentation/launch_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = AppSettings();
  await settings.load();
  final book = await BookRepository.load();
  runApp(RasmApp(settings: settings, book: book));
}

class RasmApp extends StatelessWidget {
  const RasmApp({super.key, required this.settings, required this.book});
  final AppSettings settings;
  final BookRepository book;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: settings,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'كتاب الرسم',
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) => AppBackground(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(settings.fontScale)),
              child: child!,
            ),
          ),
          home: LaunchScreen(
            home: HomeScreen(book: book, settings: settings),
          ),
        ),
      );
}
