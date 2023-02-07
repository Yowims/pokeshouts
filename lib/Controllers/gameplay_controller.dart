import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameplayController
{
  static void win(int points, BuildContext context, Function()? onPressed)
  {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.congrats),
          content: Text("${AppLocalizations.of(context)!.right_choice}$points pts"),
          actions: [
            TextButton(
              onPressed: onPressed, 
              child: const Text("OK"))
          ],
        );
      },
    );
  }

  static void lose(BuildContext context)
  {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.too_bad),
          content: Text(AppLocalizations.of(context)!.wrong_choice),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: const Text("OK"))
          ],
        );
      },
    );
  }
}