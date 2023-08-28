import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:userportal/resources/strings_manager.dart';
import 'package:userportal/screens/login_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(new AssetImage('assets/images/Back_1.png'), context);
    precacheImage(
        new AssetImage('assets/images/IBIS_logo_white_red.png'), context);
    precacheImage(new AssetImage('assets/images/verticalLine.png'), context);
    precacheImage(new AssetImage('assets/images/logo.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Back_1.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      height: MediaQuery.of(context).size.height * 0.13,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/images/IBIS_logo_white_red.png")),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage("assets/images/verticalLine.png")),
                      )),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.13,
                      height: MediaQuery.of(context).size.height * 0.13,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png")),
                      )),
                ],
              ),
              Container(child: LogInForm()),
            ],
          ),
        ),
        bottomNavigationBar: new Container(
          height: 50,
          color: Color.fromRGBO(224, 224, 235, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: new Text(
                      AppStrings.copyRightAuthor,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: IconButton(
                        tooltip: 'Službena Facebook stranica IN2 d.o.o, Inc.',
                        onPressed: () async {
                          launchUrlString("https://facebook.com/IN2grupa/");
                        },
                        icon: Icon(Icons.facebook)),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                child: IconButton(
                    tooltip: 'Službena LinkedIn stranica IN2 d.o.o, Inc.',
                    onPressed: () async {
                      launchUrlString("https://www.linkedin.com/company/in2");
                    },
                    icon: Icon(Icons.my_library_books_outlined)),
              ),
              Container(
                alignment: Alignment.center,
                child: IconButton(
                    tooltip: 'Službeno web mjesto IN2 d.o.o, Inc.',
                    onPressed: () async {
                      launchUrlString("https://www.in2.hr/");
                    },
                    icon: Icon(Icons.home_work_outlined)),
              )
            ],
          ),
        ));
  }
}
