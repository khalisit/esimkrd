import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import '../content/legal_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/primary_button.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _openEmail(BuildContext context) async {
    final email = AppConfig.supportEmail;
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=eSIM KRD Support',
    );
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(email)),
      );
    }
  }

  Future<void> _openWhatsapp(BuildContext context) async {
    final number = AppConfig.supportWhatsapp.replaceAll(RegExp(r'\D'), '');
    if (number.isEmpty) return;
    final uri = Uri.parse('https://wa.me/$number');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppConfig.supportWhatsapp)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final faq = LegalContent.supportFaq(locale);
    final hasWhatsapp = AppConfig.supportWhatsapp.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.supportTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          FadeSlideIn(
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.supportContactTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: l10n.contactEmail,
                    icon: Icons.email_outlined,
                    onPressed: () => _openEmail(context),
                  ),
                  if (hasWhatsapp) ...[
                    const SizedBox(height: 10),
                    PrimaryButton(
                      label: l10n.contactWhatsapp,
                      icon: Icons.chat_rounded,
                      onPressed: () => _openWhatsapp(context),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    AppConfig.supportEmail,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.supportFaqTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 14),
                  ...faq.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
