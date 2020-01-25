import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget that displays a red error message and then close the application
/// Use this widget in order to treat errors that the application could not run with.
class FatalAlertDialog extends AlertDialog {
  FatalAlertDialog(fatalErrorMessage) : super(
    title: Text(
      'Erreur',
      style: TextStyle(
          color: Colors.redAccent
      ),
    ),
    content: Text(fatalErrorMessage),
    actions: <Widget>[
      FlatButton(
        child: Text(
          'Fermer',
          style: TextStyle(
              color: Colors.redAccent
          ),
        ),
        onPressed: () =>
            SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      )
    ],
  );

  /// Displays the fatal [errorMessage] and exit the application
  static void showFatalError(String errorMessage, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return FatalAlertDialog(errorMessage);
        }
    );
  }
}