import 'package:calicourse_front/parameters/parameters.dart';
import 'package:flutter/material.dart';

/// Widget that displays a red error message and then close the application
/// Use this widget in order to treat errors that the application could not run with.
class CustomAlertDialog extends AlertDialog {
  CustomAlertDialog(BuildContext context, fatalErrorMessage) : super(
    title: Text(
      'Erreur',
      style: TextStyle(
        color: mainColor
      ),
    ),
    content: Text(fatalErrorMessage),
    actions: <Widget>[
      FlatButton(
        child: Text(
          'Fermer',
          style: TextStyle(
            color: mainColor
          ),
        ),
        onPressed: () => Navigator.popAndPushNamed(context, '/param')
      )
    ],
  );

  /// Displays the [errorMessage]
  static void showError(String errorMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(context, errorMessage);
      }
    );
  }
}