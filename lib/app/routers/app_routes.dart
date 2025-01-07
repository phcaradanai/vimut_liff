part of 'app_pages.dart';

abstract class Routes {
  static const home = _Paths.home;
  static const history = _Paths.history;
  static const settings = _Paths.settings;
  static const profile = _Paths.profile;
  static const jobs = _Paths.jobs;
  static const signin = _Paths.signin;
  Routes._();
  static String signInThen(String afterSuccessfulLogin) =>
      '$signin?then=${Uri.encodeQueryComponent(afterSuccessfulLogin)}';

  static String jobDetails(id) => '$jobs/$id';
}

abstract class _Paths {
  static const home = '/home';
  static const signin = '/sign-in';
  static const history = '/history';
  static const settings = '/settings';
  static const profile = '/profile';
  static const jobs = '/jobs';
  static const jobDetails = '/:id';
}
