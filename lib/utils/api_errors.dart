import '../l10n/app_localizations.dart';
import '../services/api_client.dart';

String formatApiError(AppLocalizations l10n, Object error) {
  if (error is NetworkException) {
    return l10n.offlineMessage;
  }
  if (error is ApiException && error.statusCode == 401) {
    return l10n.sessionExpired;
  }
  if (error is ApiException) {
    return error.message;
  }
  return l10n.errorGeneric(error.toString());
}

bool isNetworkError(Object error) => error is NetworkException;

bool isSessionExpired(Object error) =>
    error is ApiException && error.statusCode == 401;
