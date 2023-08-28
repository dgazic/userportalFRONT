import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';
import 'package:userportal/TicketDataTableSource.dart';
import 'package:userportal/models/ticket_model.dart';
import 'package:userportal/providers/ticket_provider.dart';
import 'package:userportal/providers/user_provider.dart';
import 'package:userportal/resources/EnumUserRoles.dart';
import 'package:userportal/resources/strings_manager.dart';
import 'package:userportal/services/network_handler/jwt_decoder.dart';
import 'package:userportal/widget/appMessages.dart';
import 'package:userportal/widget/debouncerSearch.dart';
import 'package:userportal/widget/myScaffold.dart';
import 'package:intl/intl.dart';
import 'package:hovering/hovering.dart';
import 'package:flutter_excel/excel.dart';
import 'dart:math';

class ListOfAllTicketsSuperAdminScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _listOfAllTicketsSuperAdminScreen();
  }
}

class _listOfAllTicketsSuperAdminScreen
    extends State<ListOfAllTicketsSuperAdminScreen> {
  final GlobalKey<PaginatedDataTableState> paginatedDataTableStateKey =
      GlobalKey<PaginatedDataTableState>();

  Debouncer _debouncer = new Debouncer();
  late Future<List<TicketsGetAllResponseModel>> ticketsFuture;
  late TicketsGetFilterDateRequestModel requestModel;
  List<TicketsGetAllResponseModel> filteredTickets = [];
  final ScrollController scrollController = ScrollController();
  TicketProvider ticketProvider = TicketProvider();
  UserProvider userProvider = UserProvider();
  AppMessages appMessages = AppMessages();
  List<String> selectedPriority = [];
  List<String> selectedCategory = [];
  List<String> selectedStatus = [];
  final String? userRoleId = jwtDecoder().getToken()['UserRoleId'];
  List<String> dropDownProductItemsSource = <String>['SVI'];
  List<String> dropDownHospitalItemsSource = <String>['SVI'];
  List<String> dropdownHospitalUsersSource = <String>['SVI'];
  int? Activated = 0;
  int currentSortColumn = 0;
  String searchString = '';
  String? dropdownProduct = 'SVI';
  String? dropdownHospital = 'SVI';
  String dropdownHospitalUser = 'SVI';
  var ticketNumberController = TextEditingController();
  List<String> dropDownProductDomainItemsSource = <String>['SVI'];
  String? dropdownProductDomain = 'SVI';

  var ticketTypes = ['Podrška', 'Greška', 'Novi zahtjev'];

  var ticketPriority = [
    'Ništa',
    'Niski',
    'Normalni',
    'Visoki',
    'Hitno',
    'Trenutno'
  ];
  var ticketStatus = [
    'Dodijeljen',
    'Analiza u tijeku',
    'Riješen',
    'Zatvoren',
    'Razvoj',
    'Isporuka sa slijedećom verzijom',
    'Isporučen'
  ];

  late String _startDate, _endDate;
  late final DateTime today;

  @override
  void initState() {
    today = DateTime.now();
    _startDate = DateFormat('yyyy-MM-dd')
        .format(today.add(const Duration(days: -30)))
        .toString();
    _endDate = DateFormat('yyyy-MM-dd').format(today).toString();

    super.initState();
    requestModel = new TicketsGetFilterDateRequestModel();
    requestModel.enrollmentTimeDateFrom = DateTime.parse(_startDate);
    requestModel.enrollmentTimeDateTo = DateTime.parse(_endDate);

    TicketProvider ticketProvider = TicketProvider();
    var fetchAllTickets = ticketProvider.fetchAllTickets(requestModel);
    ticketsFuture = fetchAllTickets;

    ticketProvider.GetHospitalProducts().then((products) {
      dropDownProductItemsSource.addAll(products);
      setState(() {});
    });

    ticketProvider.GetHospitals().then((hospitals) {
      dropDownHospitalItemsSource.addAll(hospitals);
      if (hospitals.isNotEmpty) {
        ticketProvider.GetHospitalUsers(null).then((hospitalUsers) {
          dropdownHospitalUsersSource.addAll(hospitalUsers);
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    return MyScaffold(
        child: ListView(
      controller: scrollController,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "PRETRAGA PO FILTERIMA",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 10),
                    filterButton(context),
                    Spacer(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: TextFormField(
                        controller: ticketNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(7),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          label: Text("Broj zadatka"),
                        ),
                        onFieldSubmitted: (value) {
                          Get.toNamed(
                              "/ticketDetail/${ticketNumberController.text}");
                          ticketNumberController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Colors.grey),
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          label: Text("Pretraga zadatka"),
                        ),
                        onChanged: (value) {
                          if (paginatedDataTableStateKey.currentState != null) {
                            _debouncer.run(() {
                              setState(() {
                                paginatedDataTableStateKey.currentState!
                                    .pageTo(0);
                                searchString = value;
                              });
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: GestureDetector(
                              onTap: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    locale: Locale("hr"),
                                    initialDate: today,
                                    firstDate: DateTime(1900),
                                    lastDate: today);
                                if (newDate == null) return;
                                setState(() {
                                  _startDate = DateFormat('yyyy-MM-dd')
                                      .format(newDate)
                                      .toString();
                                });
                              },
                              child: HoverAnimatedContainer(
                                width: MediaQuery.of(context).size.width * 0.1,
                                color: Colors.white,
                                hoverColor: Colors.grey[500],
                                child: Row(
                                  children: [
                                    Container(
                                        child: Icon(Icons.calendar_today)),
                                    SizedBox(width: 5),
                                    Container(
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                                DateFormat('dd.MM.yyyy.')
                                                    .format(DateTime.parse(
                                                        _startDate)),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: GestureDetector(
                              onTap: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    locale: Locale("hr"),
                                    initialDate: today,
                                    firstDate: DateTime.parse(_startDate),
                                    lastDate: DateTime(2100));
                                if (newDate == null) return;
                                setState(() {
                                  _endDate = DateFormat('yyyy-MM-dd')
                                      .format(newDate)
                                      .toString();
                                });
                              },
                              child: HoverAnimatedContainer(
                                width: MediaQuery.of(context).size.width * 0.1,
                                color: Colors.white,
                                hoverColor: Colors.grey[500],
                                child: Row(
                                  children: [
                                    Container(
                                        child: Icon(Icons.calendar_today)),
                                    SizedBox(width: 5),
                                    Container(
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                                DateFormat('dd.MM.yyyy.')
                                                    .format(DateTime.parse(
                                                        _endDate)),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(width: 5),
                        ElevatedButton.icon(
                            onPressed: () async {
                              requestModel.enrollmentTimeDateFrom =
                                  DateTime.parse(_startDate);
                              requestModel.enrollmentTimeDateTo =
                                  DateTime.parse(_endDate);
                              var ticketFilterFuture =
                                  ticketProvider.fetchAllTickets(requestModel);
                              ticketsFuture = ticketFilterFuture;
                              setState(() {});
                            },
                            icon: Icon(Icons.timelapse_rounded),
                            label: Text('Traži')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                      child: ElevatedButton.icon(
                          onPressed: () => {exportToExcel()},
                          icon: Icon(Icons.import_export_outlined),
                          label: Text("Izvoz u excel dokument"))),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        (dropDownProductItemsSource.length == 1 &&
                dropDownProductItemsSource[0] == 'SVI')
            ? Container()
            : Center(
                child: FutureBuilder<List<TicketsGetAllResponseModel>>(
                future: ticketsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      filteredTickets = [];
                      return Container(child: Text("Greška"));
                    }
                    var tickets = snapshot.data!;
                    if (searchString != '') {
                      tickets = tickets
                          .where((e) =>
                              e.abstract!
                                  .toLowerCase()
                                  .contains(searchString.toLowerCase()) ||
                              e.id!.toString().contains(searchString))
                          .toList();
                    }
                    if (dropdownProduct != 'SVI') {
                      tickets = tickets
                          .where((e) => e.product!
                              .toLowerCase()
                              .contains(dropdownProduct!.toLowerCase()))
                          .toList();
                    }
                    if (dropdownProductDomain != 'SVI') {
                      tickets = tickets
                          .where((e) => e.domain!
                              .toLowerCase()
                              .contains(dropdownProductDomain!.toLowerCase()))
                          .toList();
                    }
                    if (selectedCategory.isNotEmpty) {
                      tickets = tickets
                          .where((e) => selectedCategory.contains(e.type))
                          .toList();
                    }
                    if (selectedPriority.isNotEmpty) {
                      tickets = tickets
                          .where((e) => selectedPriority.contains(e.priority))
                          .toList();
                    }
                    if (selectedStatus.isNotEmpty) {
                      tickets = tickets
                          .where((e) => selectedStatus.contains(e.status))
                          .toList();
                    }
                    if (dropdownHospital != 'SVI') {
                      tickets = tickets
                          .where((e) => e.hospitalName!
                              .toLowerCase()
                              .contains(dropdownHospital!.toLowerCase()))
                          .toList();
                    }
                    if (dropdownHospitalUser != 'SVI') {
                      tickets = tickets
                          .where((e) => e.firstNameLastNameApplicant!
                              .toLowerCase()
                              .contains(dropdownHospitalUser.toLowerCase()))
                          .toList();
                    }
                    if (dropdownProduct != 'SVI' ||
                        dropdownProductDomain != 'SVI' ||
                        selectedCategory.isNotEmpty ||
                        selectedPriority.isNotEmpty ||
                        selectedStatus.isNotEmpty ||
                        dropdownHospital != 'SVI' ||
                        dropdownHospitalUser != 'SVI') {
                      paginatedDataTableStateKey.currentState!.pageTo(0);
                    }
                    filteredTickets = tickets;
                    return buildTickets(tickets);
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )),
      ],
    ));
  }

  Widget _buildUserHospitalField(Function _setter) {
    if (dropDownHospitalItemsSource.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
      height: MediaQuery.of(context).size.height * 0.055,
      width: MediaQuery.of(context).size.width,
      child: DropdownSearch<String>(
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
          border: InputBorder.none,
        )),
        dropdownBuilder: (context, selectedItem) {
          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(selectedItem!),
                ),
              ),
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
          if (newHospital != null) {
            ticketProvider.GetHospitalUsers(
                    newHospital != 'SVI' ? newHospital : null)
                .then((newHospitalUsers) {
              dropdownHospitalUsersSource.clear();
              if (newHospitalUsers.length > 0) {
                dropdownHospitalUsersSource.add('SVI');
                dropdownHospitalUsersSource.addAll(newHospitalUsers);
                dropdownHospitalUser = dropdownHospitalUsersSource[0];
                _setter(() {});
                print(dropdownHospitalUsersSource);
              }
              dropdownHospital = newHospital;
              setState(() {});
            });
          }
        },
        selectedItem: dropdownHospital,
      ),
    );
  }

  Widget _buildProductField(Function _setter) {
    if (dropDownProductItemsSource.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      width: MediaQuery.of(context).size.width,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: dropdownProduct,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: dropDownProductItemsSource.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(items),
              ),
            );
          }).toList(),
          onChanged: (String? newProduct) {
            if (newProduct != null) {
              ticketProvider.GetProductDomains(
                      newProduct != 'SVI' ? newProduct : 'SVI')
                  .then((newProductDomains) {
                dropDownProductDomainItemsSource.clear();
                if (newProductDomains.length > 0) {
                  dropDownProductDomainItemsSource.add('SVI');
                  dropDownProductDomainItemsSource.addAll(newProductDomains);
                  dropdownProductDomain = dropDownProductDomainItemsSource[0];
                  _setter(() {});
                }
                dropdownProduct = newProduct;
                setState(() {});
                _setter(() {});
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductDomainsField(Function _setter) {
    if (dropDownProductDomainItemsSource.isEmpty || dropdownProduct == 'SVI') {
      return Container(
        height: MediaQuery.of(context).size.height * 0.055,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            color: Colors.grey[300]),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              iconEnabledColor: Colors.white,
              isExpanded: true,
              value: '...',
              icon: const Icon(Icons.keyboard_arrow_down),
              items: [],
              onChanged: null),
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      width: MediaQuery.of(context).size.width,
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
        icon: const Icon(Icons.keyboard_arrow_down),
        isExpanded: true,
        value: dropdownProductDomain,
        items: dropDownProductDomainItemsSource.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(items),
            ),
          );
        }).toList(),
        onChanged: (String? newProductDomain) {
          dropdownProductDomain = newProductDomain!;
          setState(() {});
          _setter(() {});
        },
      )),
    );
  }

  Widget _buildHospitalUsersField(Function _setter) {
    if (dropdownHospitalUsersSource.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.055,
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              isExpanded: true,
              value: '...',
              icon: const Icon(Icons.keyboard_arrow_down),
              items: [],
              onChanged: null),
        ),
      );
    }
    return Container(
        height: MediaQuery.of(context).size.height * 0.055,
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            value: dropdownHospitalUsersSource.length > 1
                ? dropdownHospitalUser
                : dropdownHospitalUsersSource[0],
            icon: const Icon(Icons.keyboard_arrow_down),
            items: dropdownHospitalUsersSource.map((String items) {
              return DropdownMenuItem(
                alignment: AlignmentDirectional.centerStart,
                value: items,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(items),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newHospitalUser) {
              dropdownHospitalUser = newHospitalUser!;
              setState(() {});
              _setter(() {});
            },
          ),
        ));
  }

  Widget buildTickets(List<TicketsGetAllResponseModel> tickets) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: PaginatedDataTable(
            key: paginatedDataTableStateKey,
            source: TicketDataTableSource(tickets, (_) => {}, constraints),
            columns: [
              DataColumn(
                  label: Text(
                    'Status zadatka',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  tooltip: 'Prikaz statusa zadatka'),
              DataColumn(
                  label: Text(
                    'Broj zadatka',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  tooltip: 'Prikaz broja zadatka'),
              DataColumn(
                  label: Text(
                    'Sažetak',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  tooltip: 'Prikaz sažetka zadatka'),
              DataColumn(
                  label: Text(
                    'Kategorija',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  tooltip: 'Prikaz kategorije zadatka'),
              DataColumn(
                  label: Text(
                    'Proizvod',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  tooltip: 'Prikaz proizvoda'),
              DataColumn(
                  label: Text(
                    'Domena',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  tooltip: 'Prikaz domene'),
              DataColumn(
                  label: Text(
                    'Prioritet',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  tooltip: 'Prikaz prioriteta zadatka'),
              DataColumn(
                  label: Text(
                    'Vrijeme upisa',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  tooltip: 'Prikaz vremena upisa zadatka'),
              if (userRoleId == EnumUserRole.Administrator ||
                  userRoleId == EnumUserRole.SuperAdministrator)
                DataColumn(
                    label: Text(
                      'Prijavio/la',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    tooltip: 'Prikaz korisnika koji je prijavio/la zadatak'),
              if (userRoleId == EnumUserRole.SuperAdministrator)
                DataColumn(
                    label: Text(
                      'Ustanova',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    tooltip: 'Prikaz ustanove koja je prijavila zadatak'),
            ],
            rowsPerPage: min(30, max(1, tickets.length)),
            showFirstLastButtons: true,
            onPageChanged: (_) {
              scrollController.jumpTo(0);
            },
            showCheckboxColumn: false,
          ),
        );
      }),
    );
  }

  void exportToExcel() {
    var excel = Excel.createExcel();
    String fileName = 'ExportZadataka |${_startDate} - ${_endDate}.xlsx';
    String sheet = 'Izvoz_zadataka_u_periodu';
    Sheet sheetObject = excel['Izvoz_zadataka_u_periodu'];
    excel.setDefaultSheet(sheet);
    //spajanje cell-ova
    //sheetObject.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("E4"), customValue: "Tekst nakon spajanja cell-ova");
    var cellA1 = sheetObject.cell(CellIndex.indexByString("A1"));
    cellA1.value = "Status zadatka";
    var cellB1 = sheetObject.cell(CellIndex.indexByString("B1"));
    cellB1.value = "Broj zadatka";
    var cellC1 = sheetObject.cell(CellIndex.indexByString("C1"));
    cellC1.value = "Sažetak";
    var cellD1 = sheetObject.cell(CellIndex.indexByString("D1"));
    cellD1.value = "Kategorija";
    var cellE1 = sheetObject.cell(CellIndex.indexByString("E1"));
    cellE1.value = "Proizvod";
    var cellF1 = sheetObject.cell(CellIndex.indexByString("F1"));
    cellF1.value = "Prioritet";
    var cellG1 = sheetObject.cell(CellIndex.indexByString("G1"));
    cellG1.value = "Vrijeme upisa";
    var cellH1 = sheetObject.cell(CellIndex.indexByString("H1"));
    cellH1.value = "Prijavio/la";

    var j = 1;
    for (int i = 0; i < filteredTickets.length; i++) {
      if (i == 0) {
        j++;
      }

      var cellA = sheetObject.cell(CellIndex.indexByString('A${i + j}'));
      cellA.value = filteredTickets[i].status;

      var cellB = sheetObject.cell(CellIndex.indexByString('B${i + j}'));
      cellB.value = filteredTickets[i].id;

      var cellC = sheetObject.cell(CellIndex.indexByString('C${i + j}'));
      cellC.value = filteredTickets[i].abstract;

      var cellD = sheetObject.cell(CellIndex.indexByString('D${i + j}'));
      cellD.value = filteredTickets[i].type;

      var cellE = sheetObject.cell(CellIndex.indexByString('E${i + j}'));
      cellE.value = filteredTickets[i].product;

      var cellF = sheetObject.cell(CellIndex.indexByString('F${i + j}'));
      cellF.value = filteredTickets[i].priority;

      var cellG = sheetObject.cell(CellIndex.indexByString('G${i + j}'));
      cellG.value = filteredTickets[i].enrollmentTime;

      var cellH = sheetObject.cell(CellIndex.indexByString('H${i + j}'));
      cellH.value = filteredTickets[i].firstNameLastNameApplicant;
    }

    excel.save(fileName: fileName);
  }

  Widget filterButton(BuildContext context) {
    return MaterialButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(child: Text('Prikaz filtera')),
                        Container(
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  dropdownProduct = 'SVI';
                                  dropdownProductDomain = 'SVI';
                                  selectedPriority = [];
                                  selectedCategory = [];
                                  selectedStatus = [];
                                  dropdownHospital = 'SVI';
                                  dropdownHospitalUser = 'SVI';
                                  setState(() {});
                                  Get.back();
                                  appMessages.showInformationMessage(context, 0,
                                      AppStrings.filterDefaultOptions);
                                },
                                icon: Icon(
                                  Icons.undo,
                                ),
                                label: Text("Poništi filtere"))),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.check),
                            label: Text('U redu'))
                      ],
                    )
                  ],
                ),
                content: StatefulBuilder(
                  builder: (context, _setter) => Container(
                    width: 400,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: Text("PROIZVOD"),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                      child: _buildProductField(_setter))),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child: Text("DOMENA"),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                      child:
                                          _buildProductDomainsField(_setter))),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child: Text("KATEGORIJA"),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.055,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 2)),
                                    child: DropDownMultiSelect(
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      onChanged: (List<String> x) {
                                        setState(() {
                                          selectedCategory = x;
                                        });
                                      },
                                      options: ticketTypes,
                                      selectedValues: selectedCategory,
                                      whenEmpty: 'Odaberite kategoriju',
                                    ),
                                  )),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child: Text("PRIORITET"),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.055,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 2)),
                                    child: DropDownMultiSelect(
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      onChanged: (List<String> x) {
                                        setState(() {
                                          selectedPriority = x;
                                        });
                                      },
                                      options: ticketPriority,
                                      selectedValues: selectedPriority,
                                      whenEmpty: 'Odaberite prioritet',
                                    ),
                                  )),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child: Text("STATUS"),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.055,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 2)),
                                    child: DropDownMultiSelect(
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      onChanged: (List<String> x) {
                                        setState(() {
                                          selectedStatus = x;
                                        });
                                      },
                                      options: ticketStatus,
                                      selectedValues: selectedStatus,
                                      whenEmpty: 'Odaberite status',
                                    ),
                                  )),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child: Text("KLIJENT"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                    child: _buildUserHospitalField(_setter)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                child: Text("KORISNIK"),
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                      child:
                                          _buildHospitalUsersField(_setter))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        color: Colors.red,
        textColor: Colors.white,
        child: Row(
          children: [
            Text('Filtriraj'),
            Icon(
              Icons.sort_rounded,
              size: 20,
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ));
  }
}
