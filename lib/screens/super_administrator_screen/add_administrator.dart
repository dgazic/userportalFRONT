import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:userportal/models/register_model.dart';
import 'package:userportal/providers/user_provider.dart';
import 'package:userportal/resources/strings_manager.dart';
import 'package:userportal/widget/appMessages.dart';
import 'package:userportal/widget/myScaffold.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddHospitalAdministratorScreen extends StatefulWidget {
  const AddHospitalAdministratorScreen({Key? key}) : super(key: key);
  @override
  State<AddHospitalAdministratorScreen> createState() =>
      _AddHospitalAdministratorScreen();
}

class _AddHospitalAdministratorScreen
    extends State<AddHospitalAdministratorScreen> {
  AppMessages appMessages = new AppMessages();
  List<String> dropDownHospitalsItemsSource = <String>[];
  String? dropdownHospitalvalue = null;
  UserProvider userProvider = UserProvider();
  String dropdownvalueUserRole = 'Administrator';
  var items = ['Administrator', 'Običan korisnik'];

  String? errMessage = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late RegisterRequestModel requestModel;
  late RegisterResponseModel responseModel;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final userRoleController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    requestModel = RegisterRequestModel();
    responseModel = RegisterResponseModel();
    userProvider.GetHospitals();
    userProvider.GetHospitals().then((products) {
      dropDownHospitalsItemsSource.addAll(products);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      child: Row(
        children: [
          Column(children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Text('Vrsta korisnika',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                        child: _buildUserRoleField(),
                        width: MediaQuery.of(context).size.width * 0.15),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Text('Bolnica',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                        child: _buildUserHospitalField(),
                        width: MediaQuery.of(context).size.width * 0.15),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.94,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(230, 231, 232, 0.4),
                    border: Border(right: BorderSide(color: Colors.grey))),
              ),
            ),
          ]),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Back_App_1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Container(
                    child: _buildForm(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: formKey,
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: Column(
            children: <Widget>[
              Container(
                  child: _buildFirstNameField(),
                  width: MediaQuery.of(context).size.width * 0.6),
              SizedBox(height: 10),
              Container(
                  child: _buildLastNameField(),
                  width: MediaQuery.of(context).size.width * 0.6),
              SizedBox(height: 10),
              Container(
                  child: _buildEmailField(),
                  width: MediaQuery.of(context).size.width * 0.6),
              SizedBox(height: 10),
              Container(
                  child: _buildMobilePhoneField(),
                  width: MediaQuery.of(context).size.width * 0.6),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(child: _cancelFormInput()),
                  SizedBox(width: 15),
                  Container(child: _buildSubmitButton()),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Obavezno polje!';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            '[A-Za-z ]|[\u0110\u0160\u0166\u017D\u017E\u0107\u0111\u0161\u0167\u0109\u010C\u010D\u0158\u0159\u0106\u0110\u0160\u0166\u017D\u017E]'))
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: firstNameController,
      decoration: InputDecoration(
        hintText: 'Unesite ime korisnika',
        labelText: 'Ime korisnika',
        prefixIcon: Icon(Icons.account_circle_outlined),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(fontSize: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      ),
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Obavezno polje!';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            '[A-Za-z ]|[\u0110\u0160\u0166\u017D\u017E\u0107\u0111\u0161\u0167\u0109\u010C\u010D\u0158\u0159\u0106\u0110\u0160\u0166\u017D\u017E]'))
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: lastNameController,
      decoration: InputDecoration(
        hintText: 'Unesite prezime korisnika',
        labelText: 'Prezime korisnika',
        prefixIcon: Icon(Icons.account_circle_outlined),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(fontSize: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Obavezno polje!';
        } else {
          if (validateEmail(value) == true) {
            return 'Neispravan email!';
          } else {
            return null;
          }
        }
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
      ),
    );
  }

  Widget _buildMobilePhoneField() {
    return TextFormField(
      autocorrect: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Obavezno polje!';
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: phoneNumberController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      decoration: InputDecoration(
        hintText: 'Unesite broj mobitela',
        labelText: 'Mobitel',
        prefixIcon: Icon(Icons.mobile_friendly_outlined),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(fontSize: 15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
      ),
    );
  }

  Widget _buildUserRoleField() {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          focusedBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius:
                  const BorderRadius.all(const Radius.circular(10.0))),
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
              borderSide: BorderSide(color: Colors.grey)),
          filled: true,
          hintStyle: TextStyle(color: Colors.white),
          fillColor: Colors.white),
      // Initial Value
      value: dropdownvalueUserRole,
      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          dropdownvalueUserRole = newValue!;
        });
      },
    );
  }

  Widget _buildUserHospitalField() {
    if (dropDownHospitalsItemsSource.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
          showSelectedItems: true,
          showSearchBox: true,
          searchDelay: Duration(milliseconds: 10)),
      items: dropDownHospitalsItemsSource,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15.0),
            focusedBorder: new OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(10.0))),
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
                borderSide: BorderSide(color: Colors.grey)),
            filled: true,
            hintStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white),
      ),
      onChanged: (String? newProduct) {
        dropdownHospitalvalue = newProduct;
      },
      selectedItem: dropDownHospitalsItemsSource[0],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(100, 60), // put the width and height you want
        primary: Colors.green,
      ),
      onPressed: () async {
        await submitForm();
      },
      icon: Icon(Icons.save), //icon data for elevated button
      label: Text("DODAJ NOVOG KORISNIKA"), //label text
    );
  }

  Widget _cancelFormInput() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(100, 60) // put the width and height you want
          ),
      onPressed: () async {
        await cancelForm();
      },
      icon: Icon(Icons.cancel_outlined), //icon data for elevated button
      label: Text("OTKAŽI"), //label text
    );
  }

  submitForm() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      await userRoleMapping();
      requestModel.lastName = lastNameController.text;
      requestModel.firstName = firstNameController.text;
      requestModel.email = emailController.text;
      requestModel.username = emailController.text;
      requestModel.userRole = userRoleController.text;
      if (dropdownHospitalvalue != null) {
        requestModel.hospitalName = dropdownHospitalvalue;
      } else {
        requestModel.hospitalName = dropDownHospitalsItemsSource[0];
      }
      requestModel.phoneNumber = phoneNumberController.text;

      var dataProvider = await userProvider.register(requestModel);
      if (dataProvider.success == true) {
        lastNameController.clear();
        firstNameController.clear();
        emailController.clear();
        phoneNumberController.clear();
        formKey.currentState!.reset();
        appMessages.showInformationMessage(
            context, 1, AppStrings.userSuccesfullyAdded);
      } else {
        appMessages.showInformationMessage(
            context, 2, AppStrings.userIsAlreadyRegistered);
      }
    }
  }

  userRoleMapping() async {
    if (dropdownvalueUserRole == 'Administrator') {
      userRoleController.text = '1';
    } else if (dropdownvalueUserRole == 'Običan korisnik') {
      userRoleController.text = '2';
    }
  }

  cancelForm() {
    if (lastNameController.text != '' ||
        firstNameController.text != '' ||
        emailController.text != '') {
      appMessages.showInformationMessage(context, 2, AppStrings.entryCancelled);
      lastNameController.text = '';
      firstNameController.text = '';
      emailController.text = '';
    }
  }

  bool? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return true;
    else
      return null;
  }
}
