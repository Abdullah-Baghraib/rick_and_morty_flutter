import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_flutter/screens/home_screen.dart';
import 'package:rick_and_morty_flutter/models/character_mode.dart';
import 'package:rick_and_morty_flutter/providers/api_provider.dart';
import 'package:rick_and_morty_flutter/screens/character_screen.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      return const HomeScreen();
    },
    routes: [
      GoRoute(
        path: 'character',
        builder: (context, state) {
          final character = state.extra as Character;
          return CharacterScreen(
            character: character,
          );
        },
      ),
    ],
  )
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiProvider(),
      child: MaterialApp.router(
        title: 'Rick And Morty APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
