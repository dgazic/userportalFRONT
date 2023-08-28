import 'package:flutter/material.dart';
import 'package:userportal/services/network_handler/jwt_decoder.dart';
import 'package:userportal/widget/myScaffold.dart';

class AdministratorAccountSettings extends StatefulWidget {
  const AdministratorAccountSettings({Key? key}) : super(key: key);

  @override
  State<AdministratorAccountSettings> createState() =>
      _AdministratorAccountSettingsState();
}

class _AdministratorAccountSettingsState
    extends State<AdministratorAccountSettings> {

      String? userFullName = "";

  @override void initState() {
    super.initState();
    getLastNameFirstName();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      child: Row(
        children: [
          Text("haha")
        ],
      ),
    );
  }

  getLastNameFirstName () async {
    var token = await jwtDecoder().getToken();
    setState(() {
      userFullName = token['LastNameFirstName'];
    });
  }
}
