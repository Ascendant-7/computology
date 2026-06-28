import 'package:computology/core/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme_provider.dart';
import 'features/auth/logic/auth_provider.dart';
import 'features/cart/logic/cart_provider.dart';
import 'features/catalog/logic/favorites_provider.dart';
import 'features/profile/logic/profile_provider.dart';

import 'core/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ],
        child: Consumer2<AuthProvider, ThemeProvider>(
          builder: (context, authProvider, themeProvider, _) {
            _router ??= createGoRouter(authProvider);
            return MaterialApp.router(
              title: 'Computology',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: themeProvider.themeMode,
              routerConfig: _router!,
            );
          },
        ),
      ),
    );
  }
}
