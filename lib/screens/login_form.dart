import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:userportal/helpers/device_info_helper.dart';
import 'package:userportal/models/login_model.dart';
import 'package:userportal/providers/user_provider.dart';
import 'package:userportal/resources/EnumUserRoles.dart';
import 'package:userportal/resources/routes_manager.dart';
import 'package:userportal/resources/strings_manager.dart';
import 'package:userportal/services/network_handler/app_preferences.dart';
import 'package:userportal/widget/appMessages.dart';

class LogInForm extends StatefulWidget {
  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  AppMessages appMessages = new AppMessages();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool _isObscure = true;
  late LoginRequestModel requestModel;
  late LoginResponseModel responseModel;
  bool _isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    requestModel = LoginRequestModel();
    responseModel = LoginResponseModel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: formLogin(),
    );
  }

  Widget formLogin() {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      height: MediaQuery.of(context).size.height * 0.40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.transparent.withOpacity(0.2),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
            ),
            height: 60,
            child: Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text("PRIJAVA U KORISNIČKI PORTAL",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextFormField(
              autocorrect: false,
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Unesite e-poštu',
                labelText: 'Adresa e-pošte',
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                prefixIcon: Icon(Icons.mail, color: Colors.white),
                filled: true,
                labelStyle: TextStyle(fontSize: 12, color: Colors.white),
              ),
              keyboardType: TextInputType.emailAddress,
              autofillHints: [AutofillHints.email],
              validator: (input) {
                RegExp pattern = RegExp(
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                return pattern.hasMatch(input ?? '')
                    ? null
                    : 'Neispravan email';
              },
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextFormField(
              obscureText: _isObscure,
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: passwordController,
              onFieldSubmitted: (value) async {
                requestModel.username = emailController.text;
                requestModel.password = passwordController.text;
                setState(() {
                  _isLoading = true;
                });

                //logiranje uređaja
                AppPreferences.prefs.clear();
                requestModel.sessionUuid = AppPreferences.getUuid();
                requestModel.deviceModel =
                    await DeviceInfoHelper.getDeviceInfo();
                var dataProviderLogin = await userProvider.login(requestModel);

                if (dataProviderLogin.success == true) {
                  Map<String, dynamic> decodedToken =
                      Jwt.parseJwt(dataProviderLogin.token.toString());
                  if (decodedToken["UserRoleId"] ==
                      EnumUserRole.Administrator) {
                    Get.offAllNamed(Routes.ticketRegistrationScreen);
                  } else if (decodedToken["UserRoleId"] ==
                      EnumUserRole.SuperAdministrator) {
                    Get.offAllNamed(Routes.superAdminRegisterUser);
                  } else {
                    Get.offAllNamed(Routes.ticketRegistrationScreen);
                  }
                } else {
                  passwordController.clear();
                  setState(() {
                    _isLoading = false;
                  });
                  appMessages.showInformationMessage(
                      context, 2, AppStrings.errorLogin);
                }
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Unesite lozinku',
                labelText: 'Lozinka',
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                prefixIcon: Icon(Icons.password, color: Colors.white),
                suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    color: Colors.white,
                    onPressed: () => setState(() {
                          _isObscure = !_isObscure;
                        })),
                filled: true,
                labelStyle: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                alignment: Alignment.bottomRight,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.resetPasswordScreen);
                    },
                    child: Text('Zaboravljena lozinka?',
                        style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent.withOpacity(0.1),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ))),
          ),
          (_isLoading == false)
              ? Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        child: Center(child: Text("Prijava")),
                        onPressed: () async {
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty) {
                            requestModel.username = emailController.text;
                            requestModel.password = passwordController.text;
                            setState(() {
                              _isLoading = true;
                            });
                            //logiranje uređaja
                            AppPreferences.prefs.clear();
                            requestModel.sessionUuid = AppPreferences.getUuid();
                            requestModel.deviceModel =
                                await DeviceInfoHelper.getDeviceInfo();
                            var dataProviderLogin =
                                await userProvider.login(requestModel);
                            if (dataProviderLogin.success == true) {
                              Map<String, dynamic> decodedToken = Jwt.parseJwt(
                                  dataProviderLogin.token.toString());
                              if (decodedToken["UserRoleId"] ==
                                  EnumUserRole.Administrator) {
                                Get.offAllNamed(
                                    Routes.ticketRegistrationScreen);
                              } else if (decodedToken["UserRoleId"] ==
                                  EnumUserRole.SuperAdministrator) {
                                Get.offAllNamed(Routes.superAdminRegisterUser);
                              } else {
                                Get.offAllNamed(
                                    Routes.ticketRegistrationScreen);
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              passwordController.clear();
                              appMessages.showInformationMessage(
                                  context, 2, AppStrings.errorLogin);
                            }
                          } else {
                            passwordController.clear();
                            setState(() {
                              _isLoading = false;
                            });
                            appMessages.showInformationMessage(
                                context, 2, AppStrings.errorLogin);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white.withOpacity(0.5),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : CircularProgressIndicator(),
        ],
      ),
    );
  }
}
