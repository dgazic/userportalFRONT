import 'package:flutter/material.dart';
import 'package:userportal/resources/EnumTypeOfMassage.dart';

class AppMessages {
  void showInformationMessage(BuildContext context, int type, String content) {
    final snackbar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.info, color: Colors.white),
          SizedBox(width: 5),
          Text(content),
        ],
      ),
      backgroundColor: (type == EnumTypeOfMessage.information)
          ? Colors.blue
          : (type == EnumTypeOfMessage.success)
              ? Colors.green
              : Colors.red,
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
