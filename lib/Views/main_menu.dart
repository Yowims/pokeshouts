import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pokeshouts/Views/Designs/design_helper.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {

    @override
  Widget build(BuildContext context) {

    double scale = 0.4;

    Map<int,Image> images = {
      0: Image.asset("assets/images/pokeball.png", width: MediaQuery.of(context).size.width * scale),
      1: Image.asset("assets/images/superball.png", width: MediaQuery.of(context).size.width * scale),
      2: Image.asset("assets/images/ultraball.png", width: MediaQuery.of(context).size.width * scale),
      3: Image.asset("assets/images/masterball.png", width: MediaQuery.of(context).size.width * scale)
    };

    Map<int,String> texts = {
      0: "Facile",
      1: "Moyen",
      2: "Difficile",
      3: "Extrême"
    };

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SizedBox(
          height: 150,
          child: Center(
            child: Text("PokeShouts", style: DesignHelper.titleStyle()),
          ),
        ),
      ),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(child: images[index]),
                Text(texts[index]!, style: DesignHelper.gridTextStyle(context),)
              ],
            );
          }
        ),
      )
    );
  }
}