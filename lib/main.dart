import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';
// import 'package:url_strategy/url_strategy.dart';
import 'core/theme/app_colors.dart';
import 'features/presentation/pages/portfolio_page.dart';

void main() {
  // Remove # from URLs on web
  setPathUrlStrategy();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Developer Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          surface: AppColors.backgroundPrimary,
        ),
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
        useMaterial3: true,
      ),
      home: const PortfolioPage(),
    );
  }
}
