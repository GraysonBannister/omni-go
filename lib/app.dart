import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/constants.dart';
import 'config/theme.dart';
import 'core/lifecycle/app_lifecycle_observer.dart';
import 'presentation/providers/server_provider.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/screens/connect_screen.dart';
import 'presentation/screens/home_screen.dart';

class OmniGoApp extends ConsumerWidget {
  const OmniGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverConnection = ref.watch(serverConnectionProvider);
    final themeMode = ref.watch(themeModeProvider);

    return AppLifecycleObserver(
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: serverConnection.isConnected ? const HomeScreen() : const ConnectScreen(),
      ),
    );
  }
}
