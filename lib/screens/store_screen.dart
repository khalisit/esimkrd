import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../config/regional_countries.dart';
import '../models/country.dart';
import '../services/api_client.dart';
import '../services/locale_service.dart';
import '../theme/app_colors.dart';
import '../utils/country_names.dart';
import '../utils/api_errors.dart';
import '../utils/page_transitions.dart';
import '../widgets/country_flag_avatar.dart';
import '../widgets/country_tile.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/kurdish_region_section.dart';
import '../widgets/language_selector.dart';
import '../widgets/animated_bottom_nav.dart';
import '../widgets/error_state_view.dart';
import '../widgets/skeleton_loading.dart';
import '../widgets/search_field.dart';
import 'country_packages_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({
    super.key,
    required this.api,
    required this.localeService,
  });

  final ApiClient api;
  final LocaleService localeService;

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late Future<List<Country>> _countriesFuture;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _countriesFuture = _loadCountries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Country>> _loadCountries() async {
    final response = await widget.api.get('/packages/countries');
    final list = response['data'] as List<dynamic>;
    return list
        .map((e) => Country.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<Country> _pickByCodes(List<Country> all, List<String> codes) {
    final result = <Country>[];
    for (final code in codes) {
      final synthetic = RegionalCountries.syntheticCountry(code);
      if (synthetic != null) {
        result.add(synthetic);
        continue;
      }
      for (final country in all) {
        if (country.code == code) {
          result.add(country);
          break;
        }
      }
    }
    return result;
  }

  List<Country> _filter(List<Country> countries) {
    var result = countries.where((c) => c.code.isNotEmpty).toList();

    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      result = result.where((c) {
        final localized = CountryNames.localized(
          context,
          c.code,
          c.name,
        ).toLowerCase();
        return c.name.toLowerCase().contains(q) ||
            c.code.toLowerCase().contains(q) ||
            localized.contains(q);
      }).toList();
    }

    return result;
  }

  void _openCountry(Country country) {
    Navigator.of(context).push(
      AppPageRoute(
        page: CountryPackagesScreen(api: widget.api, country: country),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          final future = _loadCountries();
          setState(() {
            _countriesFuture = future;
          });
          try {
            await future;
          } catch (_) {}
        },
        child: FutureBuilder<List<Country>>(
          future: _countriesFuture,
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final hasError = snapshot.hasError;
            final allCountries = snapshot.data ?? [];
            final countries = _filter(allCountries);
            final regionCountries = _pickByCodes(
              allCountries,
              RegionalCountries.kurdishRegionCodes,
            );
            final popularCountries = _pickByCodes(
              allCountries,
              RegionalCountries.popularCodes,
            );

            return CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(context, allCountries, l10n),
                ),
                SliverToBoxAdapter(child: _buildSearch(l10n)),
                if (_query.isEmpty && (isLoading || regionCountries.isNotEmpty))
                  SliverToBoxAdapter(
                    child: KurdishRegionSection(
                      countries: regionCountries,
                      title: l10n.kurdistanRegion,
                      subtitle: l10n.kurdistanRegionSubtitle,
                      onCountryTap: _openCountry,
                    ),
                  ),
                if (_query.isEmpty &&
                    (isLoading || popularCountries.isNotEmpty))
                  SliverToBoxAdapter(
                    child: _buildPopularChips(popularCountries, l10n),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Text(
                      l10n.allCountries,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                if (isLoading)
                  const SliverToBoxAdapter(
                    child: CountryListSkeleton(itemCount: 8),
                  )
                else if (hasError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: ErrorStateView(
                      title: isNetworkError(snapshot.error!)
                          ? l10n.offlineTitle
                          : l10n.apiError,
                      message: formatApiError(l10n, snapshot.error!),
                      retryLabel: l10n.retry,
                      onRetry: () =>
                          setState(() => _countriesFuture = _loadCountries()),
                      icon: isNetworkError(snapshot.error!)
                          ? Icons.wifi_off_rounded
                          : Icons.cloud_off_rounded,
                    ),
                  )
                else if (countries.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(l10n.noResults)),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    sliver: SliverList.separated(
                      itemCount: countries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final country = countries[index];
                        return FadeSlideIn(
                          delay: Duration(
                            milliseconds: 40 * (index.clamp(0, 12)),
                          ),
                          child: CountryTile(
                            country: country,
                            index: index,
                            onTap: () => _openCountry(country),
                          ),
                        );
                      },
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: NavIslandLayout.bottomClearance(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    List<Country> allCountries,
    AppLocalizations l10n,
  ) {
    final totalCountries = allCountries.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeSlideIn(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l10n.destinationsCount(totalCountries),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                LanguageSelector(
                  localeService: widget.localeService,
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineLarge,
                children: [
                  TextSpan(text: l10n.heroTitlePart1),
                  TextSpan(
                    text: l10n.heroTitleHighlight,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(text: l10n.heroTitlePart2),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          FadeSlideIn(
            delay: const Duration(milliseconds: 140),
            child: Text(
              l10n.heroSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: FadeSlideIn(
        delay: const Duration(milliseconds: 260),
        child: SearchField(
          controller: _searchController,
          hint: l10n.searchCountries,
          onChanged: (value) => setState(() {
            _query = value.trim();
          }),
        ),
      ),
    );
  }

  Widget _buildPopularChips(List<Country> popular, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: FadeSlideIn(
        delay: const Duration(milliseconds: 320),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l10n.popularDestinations,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: popular.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final country = popular[index];
                  final name = CountryNames.localized(
                    context,
                    country.code,
                    country.name,
                  );
                  return ActionChip(
                    avatar: CountryFlagBadge(countryCode: country.code),
                    label: Text(name),
                    onPressed: () => _openCountry(country),
                    backgroundColor: Colors.transparent,
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
