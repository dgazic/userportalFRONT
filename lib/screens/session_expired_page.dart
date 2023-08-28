import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userportal/resources/routes_manager.dart';
import 'package:userportal/widget/appMessages.dart';

class SessionExpiredScreen extends StatelessWidget {
  AppMessages appMessages = new AppMessages();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 125.0,
                width: 125.0,
                child: Image(
                  image: AssetImage("assets/images/in2.png"),
                )),
            SizedBox(height: 20),
            Container(
                child: Text('Sesija istekla',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
            SizedBox(height: 15),
            Container(
              child: Column(children: [
                _buildForm(context),
                SizedBox(height: 20),
                Container(
                    child: ElevatedButton.icon(
                        icon: Icon(Icons.home),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // background
                          onPrimary: Colors.white,
                        ),
                        onPressed: () async {
                          Get.toNamed(Routes.home);
                        },
                        label: Text("Početna stranica")))
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(children: <Widget>[
          Container(
              padding: const EdgeInsets.all(75.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Column(
                children: [
                  Container(
                      child: Text(
                          'Sesija je istekla, molimo da se ponovno prijavite u sustav.',
                          style: TextStyle(fontSize: 16))),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.3,
                  )
                ],
              ))
        ]));
  }
}
