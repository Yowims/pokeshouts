import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokeshouts/Views/easy_mode.dart';
import 'package:pokeshouts/Views/main_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokeshouts/Views/test_pokemons.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const PokeShoutsApp());
}

class PokeShoutsApp extends StatelessWidget {
  const PokeShoutsApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'PokemonWriting'),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuPage(),
        '/easy': (context) => const EasyModePage(),
        '/test': (context) => const TestPokemonPage(),
      },
    );
  }
}
