import 'package:flutter/material.dart';
import '../../../core/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settings});
  final AppSettings settings;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('الإعدادات')),
    body: AnimatedBuilder(animation: settings, builder: (context, _) => ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: SwitchListTile(
        secondary: const Icon(Icons.dark_mode_outlined), title: const Text('الوضع الليلي'),
        value: settings.darkMode, onChanged: settings.setDarkMode,
      )),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('حجم الخط'),
        Row(children: [const Text('أ'), Expanded(child: Slider(value: settings.fontScale, min: .85, max: 1.4, divisions: 11, label: '${(settings.fontScale * 100).round()}%', onChanged: settings.setFontScale)), const Text('أ', style: TextStyle(fontSize: 24))]),
        Text('معاينة النص العربي', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
      ]))),
      const Padding(padding: EdgeInsets.all(16), child: Text('تُحفظ تفضيلاتك محلياً على الجهاز.')),
    ])),
  );
}
