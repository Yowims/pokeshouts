import 'package:flutter/material.dart';
import 'package:pokeshouts/Views/Helpers/design_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    double scale = 0.4;

    Map<int, Image> images = {
      0: Image.asset("assets/images/pokeball.png", width: MediaQuery.of(context).size.width * scale),
      1: Image.asset("assets/images/superball.png", width: MediaQuery.of(context).size.width * scale),
      2: Image.asset("assets/images/ultraball.png", width: MediaQuery.of(context).size.width * scale),
      3: Image.asset("assets/images/masterball.png", width: MediaQuery.of(context).size.width * scale),
    };

    Map<int, String> texts = {
      0: AppLocalizations.of(context)!.easy_mode,
      1: AppLocalizations.of(context)!.medium_mode,
      2: AppLocalizations.of(context)!.hard_mode,
      3: AppLocalizations.of(context)!.extreme_mode,
    };

    Map<int, String> routes = {
      0: "/easy",
      1: "/medium",
      2: "/hard",
      3: "/extreme",
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        flexibleSpace: SizedBox(
          height: 150,
          child: Center(
            child: DesignHelper.titleText(),
          ),
        ),
      ),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                try {
                  Navigator.pushNamed(context, routes[index]!);
                } catch (error) {
                  showDialog(
                    context: context,
                    builder: ((_) {
                      return AlertDialog(
                        content: Text(AppLocalizations.of(context)!.coming_soon),
                      );
                    }),
                  );
                }
              },
              child: Column(
                children: [
                  Container(child: images[index]),
                  Text(
                    texts[index]!,
                    style: DesignHelper.gridTextStyle(context),
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/test');
        },
        child: const Icon(Icons.assignment),
      ),
    );
  }
}
