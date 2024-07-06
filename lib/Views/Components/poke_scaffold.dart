import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PokeScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? dialog;
  const PokeScaffold({super.key, this.appBar, required this.body, this.dialog});

  @override
  State<PokeScaffold> createState() => PokeScaffoldState();
}

class PokeScaffoldState extends State<PokeScaffold> {
  double blurFactorBegin = 0;
  double blurFactorEnd = 3;
  bool dialogActive = false;

  void showDialog() {
    blurFactorBegin == 3 ? blurFactorBegin = 0 : blurFactorBegin = 3;
    blurFactorEnd == 0 ? blurFactorEnd = 3 : blurFactorEnd = 0;
    setState(() {
      dialogActive = !dialogActive;
    });
  }

  @override
  void initState() {
    super.initState();
    bool state1 = widget.dialog != null;
    bool state2 = widget.dialog is! AlertDialog;
    bool state3 = widget.dialog is! CupertinoAlertDialog;
    bool state4 = (state2 && state3);
    if (state1 && state4) {
      throw Exception("'dialog' parameter must be a [AlertDialog] or a [CupertinoAlertDialog].");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Stack(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: blurFactorEnd, end: blurFactorBegin),
            duration: const Duration(milliseconds: 200),
            builder: (_, value, __) {
              return ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: dialogActive ? Colors.black26 : null),
                  child: widget.body,
                ),
              );
            },
          ),
          if (widget.dialog != null)
            Visibility(
              visible: dialogActive,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: widget.dialog!,
              ),
            ),
        ],
      ),
    );
  }
}
