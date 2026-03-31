import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:saraba_mobile/repository/model/history_absensi_item_model.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:saraba_mobile/ui/common/debug/debug_log_page.dart';
import 'package:saraba_mobile/ui/common/auth/auth_wrapper.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_bloc.dart';

const bool _enableShakeLogsInRelease = bool.fromEnvironment(
  'ENABLE_SHAKE_LOGS',
  defaultValue: false,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID');
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AbsensiItemAdapter());

  await Hive.openBox<User>("userBox");
  await Hive.openBox<AbsensiItem>("absensi_history");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<AccelerometerEvent>? _shakeSubscription;
  DateTime? _lastShakeAt;
  bool _isLogPageOpen = false;

  @override
  void initState() {
    super.initState();
    _startShakeListener();
  }

  @override
  void dispose() {
    _shakeSubscription?.cancel();
    super.dispose();
  }

  void _startShakeListener() {
    if (!_isShakeLoggingEnabled) {
      return;
    }

    _shakeSubscription = accelerometerEventStream().listen((event) {
      final totalForce = math.sqrt(
        (event.x * event.x) + (event.y * event.y) + (event.z * event.z),
      );

      if (totalForce < 22) {
        return;
      }

      final now = DateTime.now();
      if (_lastShakeAt != null &&
          now.difference(_lastShakeAt!) < const Duration(seconds: 1)) {
        return;
      }

      _lastShakeAt = now;
      _openDebugLogs();
    });
  }

  bool get _isShakeLoggingEnabled => !kReleaseMode || _enableShakeLogsInRelease;

  void _openDebugLogs() {
    if (_isLogPageOpen) {
      return;
    }

    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      return;
    }

    _isLogPageOpen = true;
    navigator
        .push(
          MaterialPageRoute<void>(
            builder: (_) => const DebugLogPage(),
          ),
        )
        .whenComplete(() {
          _isLogPageOpen = false;
        });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthBloc(AuthService()))],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Saraba Mobile',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF7944D)),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
        home: const AuthWrapper(),
      ),
    );
  }
}
