import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokeshouts/Providers/pokemon_loaded_provider.dart';
import 'package:pokeshouts/Providers/round_timer_provider.dart';
import 'package:pokeshouts/Views/easy_mode.dart';
import 'package:pokeshouts/Views/main_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokeshouts/Views/test_pokemons.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => PokemonLoadedProvider())),
        ChangeNotifierProvider(create: ((context) => RoundTimerProvider())),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
