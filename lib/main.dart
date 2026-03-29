import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:saraba_mobile/repository/model/history_absensi_item_model.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';
import 'package:saraba_mobile/ui/common/auth/auth_wrapper.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_bloc.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthBloc(AuthService()))],
      child: MaterialApp(
        title: 'Saraba Mobile',
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
