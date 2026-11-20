import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
 
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('معلومات التواصل')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text(
                'يسعدني تواصلكم ومتابعتكم عبر:',
                textDirection: TextDirection.rtl,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 14),
              _ContactCard(
                icon: Icons.language_rounded,
                title: 'الموقع الإلكتروني',
                subtitle: 'افتح الموقع',
                onTap: () => launchUrl(
                  Uri.parse('https://sites.google.com/view/arrasim-book'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              const SizedBox(height: 10),
              _ContactCard(
                icon: Icons.people_alt_outlined,
                title: 'فيسبوك',
                subtitle: 'تواصل معي على فيسبوك',
                onTap: () => launchUrl(
                  Uri.parse('https://www.facebook.com/bedy.ebbe.9'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
        ),
      );
}

class _ContactCard extends StatelessWidget {
  const _ContactCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon,
              size: 27, color: Theme.of(context).colorScheme.primary),
          title: Text(title, textDirection: TextDirection.rtl),
          subtitle: Text(subtitle, textDirection: TextDirection.rtl),
        ),
      );
}
