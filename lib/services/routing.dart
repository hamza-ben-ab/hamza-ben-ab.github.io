import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uy/screens/home/home_View.dart';
import 'package:uy/screens/login_page/logInPage.dart';
import 'package:uy/screens/profile/profile_View.dart';
import 'package:uy/screens/search/search_details_page.dart';
import 'package:uy/screens/subscribe_file/subscribe_mode.dart';

PageRoute _getPageRoute(Widget child, String routeName) {
  return _FadeRoute(child: child, routeName: routeName);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({this.child, this.routeName})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation primaryAnimation,
            Animation secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation primaryAnimation,
            Animation secondaryAnimation,
            Widget child,
          ) {
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              child: child,
            );
          },
        );
}

class RoutesName {
  // ignore: non_constant_identifier_names
  static const String Login_PAGE = '/login_page';
  // ignore: non_constant_identifier_names
  static const String Home_PAGE = '/home_page';
  static const String Profile_PAGE = '/profile_page';
  static const String SignUpChoice = '/Sign_Up_choice';
  //static const String Profile_PAGE = '/profile_page';
  static const String SEARCH_DETAILS_PAGE = "/search_details_page";
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.Login_PAGE:
        return PageTransition(
            child: LoginPage(), type: PageTransitionType.leftToRightWithFade);
      case RoutesName.Home_PAGE:
        return _getPageRoute(Home(), settings.name);
      case RoutesName.Profile_PAGE:
        return _getPageRoute(ProfileView(), settings.name);
      case RoutesName.SEARCH_DETAILS_PAGE:
        return _getPageRoute(SearchDetailsPage(), settings.name);
      case RoutesName.SignUpChoice:
        return _getPageRoute(SubscribeMode(), settings.name);
      default:
        return _getPageRoute(Home(), settings.name);
    }
  }
}
