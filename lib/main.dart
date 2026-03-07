import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/trio_state.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trio/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const TrioApp());
}

class TrioApp extends StatelessWidget {
  const TrioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrioState(),
      child: Consumer<TrioState>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'TRIO',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF0A0E14),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF00F0FF),
                brightness: Brightness.dark,
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
              ),
            ),
            supportedLocales: const [
              Locale('en'),
              Locale('fr'),
              Locale('ar'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: state.locale,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) return const Locale('en');
              for (final supported in supportedLocales) {
                if (supported.languageCode == locale.languageCode) return supported;
              }
              return const Locale('en');
            },
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
