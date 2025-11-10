// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Causeries';

  @override
  String welcomeMessage(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String confirmDelete(String item) {
    return 'Are you sure you want to delete $item?';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An unexpected error occurred';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get noData => 'It\'s very quiet here...';

  @override
  String get retry => 'Retry';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String passwordTooShort(int min) {
    return 'Password must be at least $min characters';
  }
}
