import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

showGameWonAlert(BuildContext context, {required Function() onProceed}) {
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Stack(children: [
        const Align(alignment: Alignment.center, child: Confetti()),
        Container(
          color: const Color.fromARGB(230, 4, 4, 4).withAlpha(155),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Congrataulations!!! You won!!!",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onProceed.call();
                  },
                  child: const Text(
                    "Click here to start new game",
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
        ),
      ]);
    },
  );
}

showAlertDialog(BuildContext context,
    {String title = "title",
    String message = "message",
    String okButtonTitle = "OK",
    String cancelButtonTitle = "Cancel",
    Function? onTap}) {
  // set up the button
  Widget okButton = TextButton(
    child: Text(okButtonTitle),
    onPressed: () {
      onTap?.call();
      Navigator.pop(context);
    },
  );

  // set up the button
  Widget cancelButton = TextButton(
    child: Text(cancelButtonTitle),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: [
          const Align(alignment: Alignment.center, child: Confetti()),
          alert,
        ],
      );
    },
  );
}

class Confetti extends StatefulWidget {
  const Confetti({Key? key}) : super(key: key);

  @override
  State<Confetti> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<Confetti> {
  var _centerController = ConfettiController();

  @override
  void initState() {
    _centerController.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: _centerController,
      blastDirection: pi / 2,
      maxBlastForce: 5,
      minBlastForce: 1,
      emissionFrequency: 0.03,

      // 10 paticles will pop-up at a time
      numberOfParticles: 10,

      // particles will pop-up
      gravity: 0,
    );
  }
}
