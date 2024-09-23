import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/views/contact_screen.dart';
import 'package:which/views/created_screen.dart';
import 'package:which/views/delete_screen.dart';
import 'package:which/views/home_screen.dart';
import 'package:which/views/licence_screen.dart';
import 'package:which/views/privacy_screen.dart';
import 'package:which/views/profile_screen.dart';
import 'package:which/views/saved_screen.dart';
import 'package:which/views/signin_screen.dart';
import 'package:which/views/signout_screen.dart';
import 'package:which/views/term_screen.dart';

void main() {
  // ignore: prefer_const_constructors
  setUrlStrategy(PathUrlStrategy());
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          name: 'home',
          path: '/',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
          routes: [
            GoRoute(
              name: 'signin',
              path: 'signin',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const SigninScreen(),
                );
              },
            ),
            GoRoute(
              name: 'signout',
              path: 'signout',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const SignoutScreen(),
                );
              },
            ),
            GoRoute(
              name: 'delete',
              path: 'delete',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const DeleteScreen(),
                );
              },
            ),
            GoRoute(
              name: 'profile',
              path: 'profile',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const ProfileScreen(),
              ),
            ),
            GoRoute(
              name: 'created',
              path: 'created',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const CreatedScreen(),
                );
              },
            ),
            GoRoute(
              name: 'saved',
              path: 'saved',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const SavedScreen(),
                );
              },
            ),
            GoRoute(
              name: 'term',
              path: 'term',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const TermScreen(),
              ),
            ),
            GoRoute(
              name: 'privacy',
              path: 'privacy',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const PrivacyScreen(),
                );
              },
            ),
            GoRoute(
              name: 'licence',
              path: 'licence',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: const LicenceScreen(),
                );
              },
              routes: [
                GoRoute(
                  name: 'licenceDetail',
                  path: ':package',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: LicenceDetailScreen(
                        package: state.pathParameters['package']!,
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              name: 'contact',
              path: 'contact',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const ContactScreen(),
              ),
            )
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Which',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.blueGrey.shade800,
          cardColor: Colors.white,
          backgroundColor: Colors.blueGrey.shade50,
          errorColor: Colors.red,
          brightness: Brightness.light,
        ),
      ),
      routerConfig: router,
    );
  }
}
