import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:userportal/models/account_activation_model.dart';
import 'package:userportal/providers/user_provider.dart';
import 'package:userportal/resources/routes_manager.dart';

class ActivationAccountScreen extends StatefulWidget {
  const ActivationAccountScreen({Key? key, String? title}) : super(key: key);

  @override
  State<ActivationAccountScreen> createState() =>
      _ActivationAccountScreenState();
}

class _ActivationAccountScreenState extends State<ActivationAccountScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool? _activationTokenValid = true;
  final passwordController = TextEditingController();
  final passwordRepeatedController = TextEditingController();

  late ActivationAccountRequestModel requestModel;
  late ActivationAccountResponseModel responseModel;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    requestModel = ActivationAccountRequestModel();
    responseModel = ActivationAccountResponseModel();
    activationTokenValidation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Aktivacija korisničkog računa'),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle_outlined),
          ),
        ),
        body: (_activationTokenValid!)
            ? Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: _buildForm(),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Container(child: _buildUnAuthorizeActivationToken())));
  }

  Widget _buildUnAuthorizeActivationToken() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.all(75.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Column(children: [
              Container(
                  child: Text(
                      'Nažalost, Vaš aktivacijski link je istekao. Molimo Vas pokušajte ponovno.',
                      style: TextStyle(fontSize: 16))),
              SizedBox(height: 10),
              Container(
                child: ElevatedButton.icon(
                    onPressed: () {
                      Get.offAllNamed(Routes.home);
                    },
                    icon: Icon(Icons.home),
                    label: Text("Početna stranica")),
              ),
              SizedBox(height: 10),
              Container(
                child: ElevatedButton.icon(
                    onPressed: () {
                      Get.offAllNamed(Routes.resetPasswordScreen);
                    },
                    icon: Icon(Icons.password),
                    label: Text("Resetiranje lozinke")),
              ),
            ])),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildPasswordField(),
            SizedBox(height: 10),
            _buildRepeatedPasswordField(),
            SizedBox(height: 10),
            _buildSubmitButton(),
          ],
        ));
  }

  Widget _buildPasswordField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Obavezno polje!';
        }
        return null;
      },
      obscureText: _isObscure,
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: passwordController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: 'Unesite lozinku',
        labelText: 'Lozinka',
        prefixIcon: Icon(Icons.password),
        suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            color: Colors.black,
            onPressed: () => setState(() {
                  _isObscure = !_isObscure;
                })),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildRepeatedPasswordField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) {
        var res = checkPasswordsValidation(
            passwordController.text, passwordRepeatedController.text);
        if (!res) {
          return 'Lozinke se ne poklapaju!';
        }
        return null;
      },
      obscureText: _isObscure,
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: passwordRepeatedController,
      decoration: InputDecoration(
        hintText: 'Unesite ponovno lozinku',
        labelText: 'Ponovljena lozinka',
        prefixIcon: Icon(Icons.password),
        suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            color: Colors.black,
            onPressed: () => setState(() {
                  _isObscure = !_isObscure;
                })),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(100, 60) // put the width and height you want
          ),
      onPressed: () async {
        await getActivationTokenUrl();
        await submitForm();
      },
      child: Text('Aktiviraj svoj korisnički račun!'),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text("U redu", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Get.toNamed(Routes.home);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aktivacija računa"),
      content: Text("Aktivacija računa uspješno izvršena!"),
      actions: [
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

  submitForm() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      var a = await getActivationTokenUrl();
      requestModel.password = passwordController.text;
      requestModel.activationToken = a;
      var dataProvider = await userProvider.activateAccount(requestModel);
      if (dataProvider.success == true) {
        formKey.currentState!.reset();
        showAlertDialog(context);
      } else {
        Get.to(Routes.home);
      }
    }
  }

  void activationTokenValidation() async {
    String? activationTokenData = getActivationTokenUrl();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var IsActivationTokenValid =
        await userProvider.IsActivationTokenValid(activationTokenData);
    if (IsActivationTokenValid.isTokenValid!) {
      _activationTokenValid = true;
    } else {
      _activationTokenValid = false;
    }
    setState(() {});
  }

  bool checkPasswordsValidation(String password, String repeatedPassword) {
    if (password != repeatedPassword)
      return false;
    else
      return true;
  }

  String? getActivationTokenUrl() {
    var data = Get.parameters;
    String? activationToken = data['id'];
    return activationToken;
  }
}
