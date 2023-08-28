import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userportal/resources/routes_manager.dart';
import 'package:userportal/services/network_handler/jwt_decoder.dart';
import 'package:userportal/widget/myText.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({required this.smallScreen, Key? key}) : super(key: key);
  final bool smallScreen;

  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Row(
              children: [
                if (smallScreen)
                  Padding(
                    padding: const EdgeInsets.only(right: 11),
                    child: _buildMainMenuButton(context),
                  ),
                Expanded(
                  child: Row(children: [
                    Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/in2_logo.png'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 11),
                    const MyText(
                      'Korisnički portal',
                      fontSize: 13,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white,
                    )
                  ]),
                ),
                if (Get.currentRoute != Routes.home)
                  ..._buildLoggedInAppBarWidgets(constraints.maxWidth, context),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildLoggedInAppBarWidgets(maxWidth, context) {
    final String? userFirstNameLastName =
        jwtDecoder().getToken()['LastNameFirstName'];
    final String? userPortalHospitalName =
        jwtDecoder().getToken()['UserportalHospitalName'];

    Widget userFullNameText = MyText(
      userFirstNameLastName ?? "",
      fontSize: 12,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
    Widget userHospitalText = MyText(
      userPortalHospitalName ?? "",
      fontSize: 12,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );

    return [
      const SizedBox(width: 44),
      1 > 0 ? _buildVerticalDivider() : const SizedBox(),
      const SizedBox(width: 16),
      1 > 0
          ? const Icon(
              Icons.local_hospital_rounded,
              size: 35,
              color: Colors.white,
            )
          : const SizedBox(),
      const SizedBox(width: 11),
      maxWidth > 930 ? userHospitalText : Flexible(child: userHospitalText),
      const SizedBox(width: 44),
      1 > 0 ? _buildVerticalDivider() : const SizedBox(),
      const SizedBox(width: 16),
      1 > 0
          ? const Icon(
              Icons.person,
              size: 35,
              color: Colors.white,
            )
          : const SizedBox(),
      const SizedBox(width: 11),
      maxWidth > 930 ? userFullNameText : Flexible(child: userFullNameText),
      const SizedBox(width: 20),
      _buildVerticalDivider(),
      const SizedBox(width: 20),
      _buildLogoutButton(context),
    ];
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 2,
      height: 32,
      color: Colors.white,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showAlertDialog(context);
      },
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(width: 11),
            MyText(
              'Odjava',
              fontSize: 12,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMenuButton(BuildContext context) {
    return IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: const Icon(Icons.menu, color: Colors.white),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Odustani"),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text("Odjavi se", style: TextStyle(color: Colors.white)),
      onPressed: () async {
        jwtDecoder().ClearUser();
        Get.offAllNamed(Routes.home);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Upozorenje!"),
      content: Text("Želite li se odjaviti?"),
      actions: [
        cancelButton,
        continueButton,
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
}
