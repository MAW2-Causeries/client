// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Causeries';

  @override
  String welcomeMessage(String name) {
    return 'Bienvenue, $name!';
  }

  @override
  String get signIn => 'Se connecter';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String confirmDelete(String item) {
    return 'Voulez-vous vraiment supprimer $item ?';
  }

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur inattendue est survenue';

  @override
  String get networkError =>
      'Erreur réseau. Veuillez vérifier votre connexion.';

  @override
  String get noData => 'C\'est très calme ici...';

  @override
  String get retry => 'Réessayer';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get invalidEmail => 'Veuillez saisir une adresse e-mail valide';

  @override
  String invalidPassword(int min) {
    return 'Le mot de passe doit comporter au moins $min caractères';
  }
}
