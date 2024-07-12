import 'package:flutter/material.dart';

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
      return alert;
    },
  );
}
