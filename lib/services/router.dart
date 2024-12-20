import 'package:infinite_games/pages/main/details/game_details.dart';
import 'package:infinite_games/pages/main/explore/explore.dart';
import 'package:infinite_games/pages/main/profile/about/about.dart';
import 'package:infinite_games/pages/main/profile/edit_password/edit_password.dart';
import 'package:infinite_games/pages/main/profile/verify_email/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_games/pages/main/sales/sales.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/login.dart';
import '../pages/signup.dart';
import '../pages/reset_password.dart';
import '../pages/main/profile/edit_profile.dart';
import '../pages/main/home.dart';
import '../pages/main/profile/profile.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

Widget _slideTransitionHorizontal(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  const begin = Offset(1, 0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

Widget _slideTransitionVertical(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  const begin = Offset(0, 1);
  const end = Offset.zero;
  const curve = Curves.easeOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

class _ShellNavigationWrapper extends StatefulWidget {
  final Widget child;
  const _ShellNavigationWrapper({required this.child});

  @override
  State<_ShellNavigationWrapper> createState() =>
      _ShellNavigationWrapperState();
}

class _ShellNavigationWrapperState extends State<_ShellNavigationWrapper> {
  int currentPageIndex = 0;

  void onDestinationSelected(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_main.png',
                height: 25,
              ),
              const SizedBox(
                width: 8,
              ),
              Image.asset(
                'assets/logo_text.png',
                height: 25,
              ),
            ]),
        centerTitle: true,
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        currentSelectedIndex: currentPageIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class AppRouter {
  static final GoRouter router =
      GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: '/', routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: _slideTransitionHorizontal,
        );
      },
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const SignUpPage(),
          transitionsBuilder: _slideTransitionHorizontal,
        );
      },
    ),
    GoRoute(
      path: '/reset-password',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const ResetPasswordPage(),
          transitionsBuilder: _slideTransitionHorizontal,
        );
      },
    ),
    GoRoute(
      path: '/edit-profile/new-user',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final nextRoute = extra['nextRoute'] as String? ?? '/';
        const firstTimeLogin = true;
        return CustomTransitionPage(
          key: state.pageKey,
          child: EditProfilePage(
              nextRoute: nextRoute, firstTimeLogin: firstTimeLogin),
          transitionsBuilder: _slideTransitionHorizontal,
        );
      },
    ),
    GoRoute(
      path: '/edit-profile',
      pageBuilder: (context, state) {
        const firstTimeLogin = false;
        return CustomTransitionPage(
          key: state.pageKey,
          child: const EditProfilePage(firstTimeLogin: firstTimeLogin),
          transitionsBuilder: _slideTransitionVertical,
        );
      },
    ),
    GoRoute(
      path: '/edit-password',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final isPasswordValid = extra['isPasswordValid'] as bool? ?? false;
        return CustomTransitionPage(
          key: state.pageKey,
          child: EditPasswordPage(isPasswordValid: isPasswordValid),
          transitionsBuilder: _slideTransitionVertical,
        );
      },
    ),
    GoRoute(
      path: '/verify-account',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const VerifyEmailPage(),
          transitionsBuilder: _slideTransitionVertical,
        );
      },
    ),
    GoRoute(
      path: '/game-detail',
      pageBuilder: (context, state) {
        final gameId = int.parse(state.uri.queryParameters['id']!);
        return CustomTransitionPage(
          key: state.pageKey,
          child: GameDetailsPage(id: gameId),
          transitionsBuilder: _slideTransitionHorizontal,
        );
      },
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const AboutPage(),
          transitionsBuilder: _slideTransitionHorizontal,
        );
      },
    ),
    ShellRoute(
        builder: (context, state, child) {
          return _ShellNavigationWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const HomePage(),
                transitionsBuilder: _slideTransitionHorizontal,
              );
            },
          ),
          GoRoute(
            path: '/explore',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const ExplorePage(),
                transitionsBuilder: _slideTransitionHorizontal,
              );
            },
          ),
          GoRoute(
            path: '/sales',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const SalesPage(),
                transitionsBuilder: _slideTransitionHorizontal,
              );
            },
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const ProfilePage(),
                transitionsBuilder: _slideTransitionHorizontal,
              );
            },
          ),
        ])
  ]);
}
