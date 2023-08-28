import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userportal/models/user_model.dart';
import 'package:userportal/providers/ticket_provider.dart';
import 'package:userportal/providers/user_provider.dart';
import 'package:userportal/resources/strings_manager.dart';
import 'package:userportal/screens/administrator_screen/user_detail_page.dart';
import 'package:userportal/widget/appMessages.dart';
import 'package:userportal/widget/myScaffold.dart';

class ListOfUsersSuperAdminScreen extends StatefulWidget {
  const ListOfUsersSuperAdminScreen({Key? key}) : super(key: key);

  @override
  State<ListOfUsersSuperAdminScreen> createState() =>
      _ListOfUsersSuperAdminScreen();
}

class _ListOfUsersSuperAdminScreen extends State<ListOfUsersSuperAdminScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TicketProvider ticketProvider = TicketProvider();
  late Future<List<UserResponseModel>> usersFuture;
  late UserRequestModel requestModel;
  late UserResponseModel responseModel;
  List<String> dropDownHospitalItemsSource = <String>['SVI'];
  String? dropdownHospital = 'SVI';
  String searchString = '';
  int? tappedIndex = null;
  final _selection = ValueNotifier<UserResponseModel?>(null);
  AppMessages appMessages = new AppMessages();

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = UserProvider();

    var fetchUsers = userProvider.fetchUsers();
    usersFuture = fetchUsers;

    ticketProvider.GetHospitals().then((hospitals) {
      dropDownHospitalItemsSource.addAll(hospitals);
      setState(() {});
    });
    requestModel = UserRequestModel();
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
                    SizedBox(height: 100),
                    Container(
                      child: Text('Pregled svih korisnika',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Container(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Icon(Icons.search,
                                          color: Colors.grey),
                                    ),
                                    label: Text("Pretraživanje korisnika"),
                                    contentPadding:
                                        EdgeInsets.only(left: 10.0, bottom: 10),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      searchString = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              child: Text('Prikaz filtera')),
                                          Container(
                                              child: ElevatedButton.icon(
                                                  onPressed: () => {
                                                        dropdownHospital =
                                                            'SVI',
                                                        setState(() {}),
                                                        Get.back(),
                                                        appMessages
                                                            .showInformationMessage(
                                                                context,
                                                                0,
                                                                AppStrings
                                                                    .filterDefaultOptions)
                                                      },
                                                  icon: Icon(Icons.undo),
                                                  label:
                                                      Text("Poništi filtere"))),
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: CircleAvatar(
                                                  radius: 14.0,
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  child: Icon(Icons.close,
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  content: Container(
                                    height: 400,
                                    width: 400,
                                    child: Column(
                                      children: [
                                        Container(
                                          child: Text("KLIJENT"),
                                        ),
                                        Container(
                                            child: _buildUserHospitalField()),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          color: Colors.red,
                          textColor: Colors.white,
                          child: Icon(
                            Icons.sort_rounded,
                            size: 24,
                          ),
                          padding: EdgeInsets.all(16),
                          shape: CircleBorder(),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: buildListView((val) {
                        _selection.value = val;
                      }),
                    )
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
                    child: Expanded(
                      child: ValueListenableBuilder<UserResponseModel?>(
                        valueListenable: _selection,
                        builder: (context, user, child) {
                          if (user == null) {
                            return Container(
                              child: Text("Nema odabranog korisnika"),
                            );
                          }
                          return UserDetail(user: user);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListView(ValueChanged<UserResponseModel> onSelected) {
    return Container(
        child: FutureBuilder<List<UserResponseModel>>(
      future: usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var users = snapshot.data!;
          if (searchString != '') {
            users = users
                .where((e) =>
                    e.firstName!
                        .toLowerCase()
                        .contains(searchString.toLowerCase()) ||
                    e.lastName!
                        .toLowerCase()
                        .contains(searchString.toLowerCase()))
                .toList();
          }
          if (dropdownHospital != 'SVI') {
            users = users
                .where((e) => e.hospital!
                    .toLowerCase()
                    .contains(dropdownHospital!.toLowerCase()))
                .toList();
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                child: ListTile(
                    tileColor: tappedIndex == index ? Colors.grey[300] : null,
                    onTap: () {
                      setState(() {
                        tappedIndex = index;
                        onSelected(user);
                      });
                    },
                    selectedColor: Colors.black,
                    title: Text(user.lastName! + ' ' + user.firstName!),
                    trailing: Text(user.hospital!,
                        style: TextStyle(fontWeight: FontWeight.bold))),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }

  Widget _buildUserHospitalField() {
    if (dropDownHospitalItemsSource.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Material(
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width,
        child: DropdownSearch<String>(
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(border: InputBorder.none),
          ),
          dropdownBuilder: (context, selectedItem) {
            return Row(
              children: [
                Container(child: Icon(Icons.business_center_outlined)),
                Expanded(child: Center(child: Text(selectedItem!))),
              ],
            );
          },
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            showSearchBox: true,
            searchDelay: Duration(milliseconds: 10),
          ),
          items: dropDownHospitalItemsSource,
          onChanged: (String? newHospital) {
            dropdownHospital = newHospital;
            setState(() {});
          },
          selectedItem: dropdownHospital,
        ),
      ),
    );
  }
}
