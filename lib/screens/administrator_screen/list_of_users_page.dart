import 'package:flutter/material.dart';
import 'package:userportal/models/user_model.dart';
import 'package:userportal/providers/user_provider.dart';
import 'package:userportal/screens/administrator_screen/user_detail_page.dart';
import 'package:userportal/widget/myScaffold.dart';

class ListOfUsersScreen extends StatefulWidget {
  const ListOfUsersScreen({Key? key}) : super(key: key);

  @override
  State<ListOfUsersScreen> createState() => _ListOfUsersScreen();
}

class _ListOfUsersScreen extends State<ListOfUsersScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late Future<List<UserResponseModel>> usersFuture;
  late UserRequestModel requestModel;
  late UserResponseModel responseModel;
  String searchString = '';
  int? tappedIndex = null;
  final _selection = ValueNotifier<UserResponseModel?>(null);

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = UserProvider();
    var fetchUsers = userProvider.fetchUsers();
    usersFuture = fetchUsers;

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
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
