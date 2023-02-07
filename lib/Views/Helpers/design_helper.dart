import 'package:flutter/material.dart';

class DesignHelper
{
  static TextStyle gridTextStyle(BuildContext context)
  {
    return const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  }

  static TextStyle titleStyle()
  {
    return const TextStyle(fontSize: 36, fontFamily: 'PokemonTitle', fontWeight: FontWeight.bold);
  }

  static Text titleText()
  {
    return Text("PokeShouts", style: DesignHelper.titleStyle());
  }

}