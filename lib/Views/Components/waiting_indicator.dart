import "package:flutter/material.dart";

class WaitingIndicator extends StatelessWidget {

  final String? text ;

  WaitingIndicator([this.text]);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          text != null ? Text(text!) : const Text("")
        ],
      ),
    );
  }
}
