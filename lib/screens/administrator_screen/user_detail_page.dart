import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userportal/models/user_model.dart';
import 'package:userportal/providers/user_provider.dart';
import 'package:userportal/resources/strings_manager.dart';
import 'package:userportal/widget/appMessages.dart';

class UserDetail extends StatefulWidget {
  final UserResponseModel user;
  const UserDetail({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AppMessages appMessages = new AppMessages();
  late TextEditingController? userFirstNameController = TextEditingController();
  late TextEditingController? userLastNameController = TextEditingController();
  late TextEditingController userMobilePhoneNumberController =
      TextEditingController();
  late TextEditingController? userEmailAdressController =
      TextEditingController();
  late final userRoleController = TextEditingController();
  late TextEditingController? userActivatedController = TextEditingController();
  late UserRequestModel requestModel;
  late UserResponseModel responseModel;
  late bool Activated;
  late bool newVActivated;

  String dropdownUserRoleValue = '';
  var items = ['Administrator', 'Običan korisnik'];

  @override
  void initState() {
    requestModel = UserRequestModel();
    super.initState();
    if (widget.user.activated == 1) {
      Activated = true;
    } else {
      Activated = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
            child: ElevatedButton.icon(
                onPressed: null,
                icon: Icon(Icons.settings),
                label: Text('POSTAVKE KORISNIČKOG RAČUNA')),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 2.0, color: Colors.grey)))),
        SizedBox(height: 10),
        Form(
            key: formKey,
            child: Center(
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                        child: _buildFirstName(),
                        width: MediaQuery.of(context).size.width * 0.60),
                    SizedBox(height: 10),
                    Container(
                        child: _buildLastName(),
                        width: MediaQuery.of(context).size.width * 0.60),
                    SizedBox(height: 10),
                    Container(
                        child: _buildEmailAdress(),
                        width: MediaQuery.of(context).size.width * 0.60),
                    SizedBox(height: 10),
                    Container(
                        child: _buildMobilePhoneNumber(),
                        width: MediaQuery.of(context).size.width * 0.60),
                    SizedBox(height: 10),
                    Container(
                        child: _buildUserRoleField(),
                        width: MediaQuery.of(context).size.width * 0.60),
                    SizedBox(height: 10),
                    Container(
                        child: _buildUserActivated(),
                        width: MediaQuery.of(context).size.width * 0.60),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              child: _userActivityButton(),
                              width: MediaQuery.of(context).size.width * 0.2,
                              height:
                                  MediaQuery.of(context).size.height * 0.050),
                          SizedBox(width: 10),
                          Container(
                              child: _userSaveButton(),
                              width: MediaQuery.of(context).size.width * 0.2,
                              height:
                                  MediaQuery.of(context).size.height * 0.050)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    ));
  }

  ElevatedButton _userSaveButton() => ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(100, 60), // put the width and height you want
        backgroundColor: Colors.green,
      ),
      onPressed: () async {
        await updateUserForm();
      },
      icon: Icon(Icons.save),
      label: Text('SPREMI'));

  ElevatedButton _userActivityButton() => ElevatedButton.icon(
        onPressed: () async {
          await activateDeactivateUser(widget.user.id!);
          if (Activated) {
            Activated = false;
          } else {
            Activated = true;
          }
          (Activated) ? widget.user.activated = 1 : widget.user.activated = 0;
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
            minimumSize: Size(100, 60),
            primary: Colors.white,
            side: (widget.user.activated == 1)
                ? BorderSide(width: 2.0, color: Colors.red)
                : BorderSide(width: 2.0, color: Colors.green)),
        icon: (widget.user.activated == 1)
            ? Icon(
                Icons.cancel,
                color: Colors.red,
              )
            : Icon(
                Icons.check,
                color: Colors.green,
              ),
        label: (widget.user.activated == 1)
            ? Text("DEAKTIVIRAJ", style: TextStyle(color: Colors.red))
            : Text('AKTIVIRAJ', style: TextStyle(color: Colors.green)),
      );

  Widget _buildFirstName() {
    return TextFormField(
      autocorrect: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Obavezno polje!';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: userFirstNameController!..text = '${widget.user.firstName}',
      decoration: InputDecoration(
        labelText: 'Ime korisnika',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.app_registration),
        labelStyle: TextStyle(fontSize: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      ),
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      autocorrect: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Obavezno polje!';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: userLastNameController!..text = '${widget.user.lastName}',
      decoration: InputDecoration(
        labelText: 'Prezime korisnika',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.app_registration),
        labelStyle: TextStyle(fontSize: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      ),
    );
  }

  Widget _buildEmailAdress() {
    return TextFormField(
      autocorrect: true,
      readOnly: true,
      controller: userEmailAdressController!..text = '${widget.user.email}',
      decoration: InputDecoration(
        labelText: 'Email adresa',
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(Icons.email),
        labelStyle: TextStyle(fontSize: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      ),
    );
  }

  Widget _buildMobilePhoneNumber() {
    return TextFormField(
      autocorrect: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: userMobilePhoneNumberController
        ..text = '${widget.user.phoneNumber ?? ''}',
      decoration: InputDecoration(
        labelText: 'Broj mobitela',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.phone),
        labelStyle: TextStyle(fontSize: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      ),
    );
  }

  Widget _buildUserActivated() {
    return TextFormField(
      autocorrect: true,
      style: TextStyle(
          color: (widget.user.activated == 1) ? Colors.green : Colors.red),
      readOnly: true,
      controller: userActivatedController!
        ..text =
            (widget.user.activated == 1) ? 'RAČUN AKTIVAN' : 'RAČUN NEAKTIVAN',
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(
          Icons.shield_rounded,
          color: (widget.user.activated == 1) ? Colors.green : Colors.red,
        ),
        labelStyle: TextStyle(fontSize: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      ),
    );
  }

  Widget _buildUserRoleField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          prefixIcon: Icon(Icons.roller_shades),
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
      value: widget.user.userRoleName,
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
          dropdownUserRoleValue = newValue!;
        });
      },
    );
  }

  updateUserForm() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      userRoleMapping();
      requestModel.id = widget.user.id;
      requestModel.firstName = userFirstNameController?.text;
      requestModel.lastName = userLastNameController?.text;
      requestModel.phoneNumber = userMobilePhoneNumberController.text;
      requestModel.userRoleId = int.parse(userRoleController.text);
      var dataProvider = await userProvider.updateUser(requestModel);
      if (dataProvider.success == true) {
        formKey.currentState!.save();
        widget.user.phoneNumber = userMobilePhoneNumberController.text;
        widget.user.firstName = userFirstNameController?.text;
        widget.user.lastName = userLastNameController?.text;
        setState(() {});
        appMessages.showInformationMessage(
            context, 1, AppStrings.userDataUpdated);
      } else {
        appMessages.showInformationMessage(
            context, 2, AppStrings.userDataUpdatedFailed);
      }
    }
  }

  activateDeactivateUser(int id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    requestModel.id = id;
    var dataProvider = await userProvider.activateDeactivateUser(requestModel);
    if (dataProvider.success == true) {
      formKey.currentState!.reset();
      setState(() {});
      appMessages.showInformationMessage(
          context, 1, AppStrings.userDataUpdated);
    } else {
      appMessages.showInformationMessage(
          context, 2, AppStrings.userDataUpdatedFailed);
    }
  }

  userRoleMapping() {
    if (dropdownUserRoleValue == 'Administrator') {
      userRoleController.text = '1';
    } else if (dropdownUserRoleValue == 'Običan korisnik') {
      userRoleController.text = '2';
    } else if (dropdownUserRoleValue == '') {
      userRoleController.text = widget.user.userRoleId.toString();
    }
  }
}
