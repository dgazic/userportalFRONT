import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userportal/models/reset_password_model.dart';
import 'package:userportal/providers/user_provider.dart';
import 'package:userportal/resources/strings_manager.dart';
import 'package:userportal/widget/appMessages.dart';

class ResetPassowrdScreen extends StatefulWidget {
  const ResetPassowrdScreen({Key? key}) : super(key: key);

  @override
  State<ResetPassowrdScreen> createState() => _ResetPassowrdScreenState();
}

class _ResetPassowrdScreenState extends State<ResetPassowrdScreen> {
  AppMessages appMessages = new AppMessages();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late ResetPasswordRequestModel requestModel;

  var emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    requestModel = ResetPasswordRequestModel();
  }

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
                child: Text('Resetirajte lozinku',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
            SizedBox(height: 15),
            Container(
              child: Column(children: [
                _buildForm(),
                SizedBox(height: 20),
                Container(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white,
                  ),
                  onPressed: () async {
                    await submitForm();
                  },
                  child: Text('Pošalji email za resetiranje lozinke'),
                ))
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
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
                          'Unesite svoju već registriranu elektroničku adresu i mi ćemo Vam poslati link za resetiranje lozinke.',
                          style: TextStyle(fontSize: 16))),
                  SizedBox(height: 20),
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextFormField(
                        autocorrect: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Obavezno polje!';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Unesite email korisnika',
                          labelText: 'Email korisnika',
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(fontSize: 15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ))
                ],
              ))
        ]));
  }

  submitForm() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      requestModel.email = emailController.text;
      var dataProvider = await userProvider.resetPassword(requestModel);
      if (dataProvider.success == true) {
        formKey.currentState!.reset();
        appMessages.showInformationMessage(
            context, 0, AppStrings.passwordResetLinkSent);
      } else {
        appMessages.showInformationMessage(
            context, 2, AppStrings.emailIsNotValid);
      }
    }
  }
}
