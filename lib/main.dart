import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/dark_mode_scope.dart';
import 'core/theme/dark_mode_storage.dart';
import 'features/breathing/presentation/bloc/breathing_bloc.dart';
import 'features/breathing/presentation/screens/pace_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const BreathingApp());
}

class BreathingApp extends StatefulWidget {
  const BreathingApp({super.key});

  @override
  State<BreathingApp> createState() => _BreathingAppState();
}

class _BreathingAppState extends State<BreathingApp> {
  bool _isDark = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSaved());
  }

  Future<void> _loadSaved() async {
    bool saved = false;
    try {
      saved = await DarkModeStorage.getIsDark();
    } catch (_) {
      // Channel not ready or platform error; keep default.
    }
    if (mounted) {
      setState(() {
      _isDark = saved;
      _loaded = true;
    });
    }
  }

  void _toggleDark() {
    setState(() => _isDark = !_isDark);
    DarkModeStorage.setIsDark(_isDark);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(body: Center(child: CircularProgressIndicator())));
    }
    return BlocProvider(
      create: (_) => BreathingBloc(),
      child: DarkModeScope(
        isDark: _isDark,
        toggleDark: _toggleDark,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Breathing',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
          home: const PaceScreen(),
        ),
      ),
    );
  }
}
