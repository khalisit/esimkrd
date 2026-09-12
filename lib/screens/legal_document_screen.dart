import 'package:flutter/material.dart';

import '../content/legal_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_slide_in.dart';

enum LegalDocumentType { terms, privacy }

class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({super.key, required this.type});

  final LegalDocumentType type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final title = type == LegalDocumentType.terms
        ? l10n.termsTitle
        : l10n.privacyTitle;
    final paragraphs = type == LegalDocumentType.terms
        ? LegalContent.terms(locale)
        : LegalContent.privacy(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        itemCount: paragraphs.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return FadeSlideIn(
            delay: Duration(milliseconds: 40 * index),
            child: Text(
              paragraphs[index],
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          );
        },
      ),
    );
  }
}
