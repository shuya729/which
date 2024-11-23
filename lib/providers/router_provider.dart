import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/views/contact_screen.dart';
import 'package:which/views/create_screen.dart';
import 'package:which/views/created_screen.dart';
import 'package:which/views/delete_screen.dart';
import 'package:which/views/notfound_screen.dart';
import 'package:which/views/home_screen.dart';
import 'package:which/views/license_screen.dart';
import 'package:which/views/privacy_screen.dart';
import 'package:which/views/profile_screen.dart';
import 'package:which/views/regist_screen.dart';
import 'package:which/views/saved_screen.dart';
import 'package:which/views/setup_screen.dart';
import 'package:which/views/signin_screen.dart';
import 'package:which/views/signout_screen.dart';
import 'package:which/views/term_screen.dart';
import 'package:which/views/users_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: HomeScreen.absolutePath,
        builder: (context, state) {
          final String? id = state.uri.queryParameters['id'];
          return HomeScreen(id: id);
        },
        routes: [
          GoRoute(
            path: CreateScreen.relativePath,
            pageBuilder: (context, state) => const MaterialPage(
              child: CreateScreen(),
              fullscreenDialog: true,
            ),
          ),
          GoRoute(
            path: SigninScreen.relativePath,
            builder: (context, state) => const SigninScreen(),
          ),
          GoRoute(
            path: RegistScreen.relativePath,
            builder: (context, state) => const RegistScreen(),
          ),
          GoRoute(
            path: SignoutScreen.relativePath,
            builder: (context, state) => const SignoutScreen(),
          ),
          GoRoute(
            path: DeleteScreen.relativePath,
            builder: (context, state) => const DeleteScreen(),
          ),
          GoRoute(
            path: ProfileScreen.relativePath,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: SetupScreen.relativePath,
            builder: (context, state) => const SetupScreen(),
          ),
          GoRoute(
            path: CreatedScreen.relativePath,
            builder: (context, state) => const CreatedScreen(),
          ),
          GoRoute(
            path: SavedScreen.relativePath,
            builder: (context, state) => const SavedScreen(),
          ),
          GoRoute(
            path: UsersScreen.relativePath,
            builder: (context, state) {
              return UsersScreen(authId: state.pathParameters['authId']!);
            },
          ),
        ],
      ),
      GoRoute(
        path: TermScreen.absolutePath,
        builder: (context, state) => const TermScreen(),
      ),
      GoRoute(
        path: PrivacyScreen.absolutePath,
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: LicenseScreen.absolutePath,
        builder: (context, state) => const LicenseScreen(),
        routes: [
          GoRoute(
            path: LicenseDetailScreen.relativePath,
            builder: (context, state) {
              return LicenseDetailScreen(
                package: state.pathParameters['package']!,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: ContactScreen.absolutePath,
        builder: (context, state) => const ContactScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotfoundScreen(),
  );
});
