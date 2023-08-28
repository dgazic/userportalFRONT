import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:userportal/models/ticket_attachment_model.dart';
import 'package:userportal/models/ticket_model.dart';
import 'package:userportal/providers/ticket_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:userportal/resources/strings_manager.dart';
import 'package:userportal/widget/appMessages.dart';
import 'package:userportal/widget/myScaffold.dart';

class TicketRegistrationScreen extends StatefulWidget {
  const TicketRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<TicketRegistrationScreen> createState() =>
      _TicketRegistrationScreenState();
}

class _TicketRegistrationScreenState extends State<TicketRegistrationScreen> {
  AppMessages appMessages = new AppMessages();
  String dropdownTaskType = 'Podrška';
  var taskTypes = ['Podrška', 'Greška', 'Novi zahtjev'];

  String? dropdownProduct = null;
  String? dropdownProductDomain = null;
  DateTime? loginClickTime;

  String dropdownPriority = 'Normalni';
  var taskPriority = [
    'Normalni',
    'Ništa',
    'Niski',
    'Visoki',
    'Hitno',
    'Trenutno'
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final abstractController = TextEditingController();
  final descriptionController = TextEditingController();
  final taskTypeController = TextEditingController();
  final productController = TextEditingController();
  final taskPriorityController = TextEditingController();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  TicketProvider ticketProvider = TicketProvider();

  late TicketRegistrationRequestModel requestModel;
  late TicketRegistrationResponseModel responseModel;
  late bool isLoading;
  List<TicketAttachmentModel> recordDocuments = <TicketAttachmentModel>[];

  List<String> dropDownProductItemsSource = <String>[];
  List<String> dropDownProductDomainItemsSource = <String>[];

  int? registeredTicketId;

  @override
  void dispose() {
    super.dispose();
    abstractController.dispose();
    descriptionController.dispose();
    taskTypeController.dispose();
    productController.dispose();
    taskPriorityController.dispose();
  }

  @override
  void initState() {
    isLoading = false;
    super.initState();
    requestModel = TicketRegistrationRequestModel();
    responseModel = TicketRegistrationResponseModel();

    ticketProvider.GetHospitalProducts().then((products) {
      dropDownProductItemsSource = products;

      if (products.isNotEmpty) {
        ticketProvider.GetProductDomains(products[0]).then((productDomains) {
          dropDownProductDomainItemsSource = productDomains;
          setState(() {});
        });
      }
    });
  }

  bool isRedundentClick(DateTime currentTime) {
    if (loginClickTime == null) {
      loginClickTime = currentTime;
      return false;
    }
    if (currentTime.difference(loginClickTime!).inSeconds < 10) {
      return true;
    }
    loginClickTime = currentTime;
    return false;
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
                        child: Text('Kategorija',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                        child: _buildtaskTypeField(),
                        width: MediaQuery.of(context).size.width * 0.15),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Text('Prioritet',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                        child: _buildtaskPriorityField(),
                        width: MediaQuery.of(context).size.width * 0.15),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Text('Proizvod',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                        child: _buildProductField(),
                        width: MediaQuery.of(context).size.width * 0.15),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Text('Domena',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                        child: _buildProductDomainsField(),
                        width: MediaQuery.of(context).size.width * 0.15)
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
                    child: _buildForm(context),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: formKey,
        child: Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                children: <Widget>[
                  Container(
                      child: _buildAbstract(),
                      width: MediaQuery.of(context).size.width * 0.6),
                  SizedBox(height: 10),
                  Container(
                      child: _buildDescription(),
                      width: MediaQuery.of(context).size.width * 0.6),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue),
                                  icon: Icon(
                                    Icons.attach_file,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  label: Text('Pregled priloga'),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Stack(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        child: Text(
                                                            'Prikaz priloga')),
                                                    MouseRegion(
                                                      cursor: SystemMouseCursors
                                                          .click,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: CircleAvatar(
                                                            radius: 14.0,
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[300],
                                                            child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            content:
                                                showAttachmentList(context),
                                          );
                                        });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            height: 50,
                            width: 250,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                var result = await FilePicker.platform
                                    .pickFiles(
                                        allowMultiple: true,
                                        type: FileType.custom,
                                        allowedExtensions: [
                                      'jpg',
                                      'png',
                                      'doc',
                                      'pdf',
                                      'mp4'
                                    ]);
                                if (result != null) {
                                  for (var file in result.files) {
                                    recordDocuments.add(TicketAttachmentModel(
                                        documentData: file.bytes!,
                                        documentExtension: file.extension!,
                                        size: file.size,
                                        title: file.name));
                                  }
                                  appMessages.showInformationMessage(context, 1,
                                      AppStrings.attachmentSuccesfullyAdded);
                                }
                              },
                              icon: Icon(Icons.document_scanner),
                              label: Text('Dodavanje priloga'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue),
                            )),
                        SizedBox(width: 10),
                        Container(
                            child: (isLoading == false)
                                ? _buildSubmitButton()
                                : CircularProgressIndicator.adaptive()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget showAttachmentList(BuildContext context) {
    return Stack(
      children: <Widget>[
        StatefulBuilder(
          builder: (context, _setter) => Container(
            height: 400.0,
            width: 400.0,
            child: (recordDocuments.length != 0)
                ? new ListView.builder(
                    itemCount: recordDocuments.length,
                    itemBuilder: (context, int index) {
                      return new GestureDetector(
                        onTap: () => openDocument(index),
                        child: HoverAnimatedContainer(
                          hoverColor: Colors.grey[200],
                          child: ListTile(
                              leading: (recordDocuments[index]
                                              .documentExtension ==
                                          'png' ||
                                      recordDocuments[index]
                                              .documentExtension ==
                                          'jpeg' ||
                                      recordDocuments[index]
                                              .documentExtension ==
                                          'jpg')
                                  ? Icon(Icons.picture_in_picture)
                                  : (recordDocuments[index].documentExtension ==
                                          'pdf')
                                      ? Icon(Icons.picture_as_pdf)
                                      : (recordDocuments[index]
                                                  .documentExtension ==
                                              'doc')
                                          ? Icon(Icons.wordpress)
                                          : Icon(Icons.media_bluetooth_off),
                              title: Text(recordDocuments[index].title),
                              trailing: Container(
                                width: 80,
                                child: Row(children: [
                                  Expanded(
                                      child: Material(
                                    type: MaterialType.transparency,
                                    child: IconButton(
                                        onPressed: () {
                                          recordDocuments.removeAt(index);
                                          _setter(() {});
                                          setState(() {});
                                          recordDocuments;
                                          appMessages.showInformationMessage(
                                              context,
                                              0,
                                              AppStrings
                                                  .attachmentSuccesfullyRemoved);
                                        },
                                        icon: Icon(Icons.delete)),
                                  ))
                                ]),
                              )),
                        ),
                      );
                    },
                  )
                : Container(
                    child: Center(child: Text("Nema odabranih priloga"))),
          ),
        ),
      ],
    );
  }

  Widget _buildAbstract() {
    return TextFormField(
      maxLength: 128,
      autocorrect: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Obavezno polje!';
        }
        return null;
      },
      autovalidateMode: _autovalidate,
      controller: abstractController,
      decoration: InputDecoration(
        hintText: 'Unesite sažetak prijave',
        labelText: 'Sažetak prijave',
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.app_registration),
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
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      ),
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      autocorrect: false,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Obavezno polje!';
        }
        return null;
      },
      keyboardType: TextInputType.multiline,
      minLines: 7,
      maxLines: null,
      autovalidateMode: _autovalidate,
      controller: descriptionController,
      decoration: InputDecoration(
        hintText: 'Unesite opis prijave',
        labelText: 'Opis prijave',
        prefixIcon: Icon(Icons.description),
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

  Widget _buildtaskTypeField() {
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
      value: dropdownTaskType,
      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: taskTypes.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          dropdownTaskType = newValue!;
        });
      },
    );
  }

  Widget _buildtaskPriorityField() {
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
      value: dropdownPriority,
      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: taskPriority.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          dropdownPriority = newValue!;
        });
      },
    );
  }

  Widget _buildProductField() {
    if (dropDownProductItemsSource.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

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
      value: dropDownProductItemsSource[0],
      icon: const Icon(Icons.keyboard_arrow_down),
      items: dropDownProductItemsSource.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newProduct) {
        if (newProduct != null) {
          ticketProvider.GetProductDomains(newProduct)
              .then((newProductDomains) {
            dropDownProductDomainItemsSource = newProductDomains;
            setState(() {
              dropdownProduct = newProduct;
            });
          });
        }
      },
    );
  }

  Widget _buildProductDomainsField() {
    if (dropDownProductDomainItemsSource.isEmpty) {
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
              fillColor: Colors.grey[200]),
          value: '...',
          icon: const Icon(Icons.keyboard_arrow_down),
          items: [],
          onChanged: null);
    }

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
      value: dropDownProductDomainItemsSource[0],
      icon: const Icon(Icons.keyboard_arrow_down),
      items: dropDownProductDomainItemsSource.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: SizedBox(width: 130.0, child: Text(items)),
        );
      }).toList(),
      onChanged: (String? newProductDomain) {
        setState(() {
          dropdownProductDomain = newProductDomain!;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(100, 60) // put the width and height you want
          ),
      onPressed: () async {
        if (isRedundentClick(DateTime.now())) {
          return;
        }
        await submitForm();
      },
      child: Text('Prijava'),
    );
  }

  submitForm() async {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      await ticketCategoryMapping();
      await ticketPriorityMapping();
      requestModel.abstract = abstractController.text;
      requestModel.description = descriptionController.text;
      requestModel.ticketType = taskTypeController.text;
      if (dropdownProduct != null) {
        requestModel.product = dropdownProduct;
      } else {
        requestModel.product = dropDownProductItemsSource[0];
      }
      if (dropdownProductDomain != null) {
        requestModel.domain = dropdownProductDomain;
      } else if (dropDownProductDomainItemsSource.isNotEmpty) {
        requestModel.domain = dropDownProductDomainItemsSource[0];
      } else {
        requestModel.domain = '';
      }
      requestModel.priority = taskPriorityController.text;
      requestModel.recordDocuments = recordDocuments;
      var dataProvider = await ticketProvider.ticketRegistration(requestModel);
      if (dataProvider.success == true) {
        registeredTicketId = dataProvider.ticketId;
        abstractController.clear();
        descriptionController.clear();
        recordDocuments.clear();
        isLoading = false;
        showAlertDialog(context);
      } else {
        _autovalidate = AutovalidateMode.always;
        appMessages.showInformationMessage(
            context, 2, AppStrings.registrationTicketError);
        isLoading = false;
      }
      setState(() {});
    }
  }

  ticketPriorityMapping() {
    if (dropdownPriority == 'Normalni') {
      taskPriorityController.text = 'Normalni';
    } else if (dropdownPriority == 'Ništa') {
      taskPriorityController.text = 'Ništa';
    } else if (dropdownPriority == 'Niski') {
      taskPriorityController.text = 'Niski';
    } else if (dropdownPriority == 'Visoki') {
      taskPriorityController.text = 'Visoki';
    } else if (dropdownPriority == 'Hitno') {
      taskPriorityController.text = 'Hitno';
    } else if (dropdownPriority == 'Trenutno') {
      taskPriorityController.text = 'Trenutno';
    }
  }

  ticketCategoryMapping() async {
    if (dropdownTaskType == 'Podrška') {
      taskTypeController.text = 'Podrška';
    } else if (dropdownTaskType == 'Greška') {
      taskTypeController.text = 'Greška';
    } else if (dropdownTaskType == 'Novi zahtjev') {
      taskTypeController.text = 'Novi zahtjev';
    }
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text("U redu", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Get.back();
      },
    );

    Widget openTicketButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: Text("Pregled prijavljenog zadatka - br. ${registeredTicketId}",
          style: TextStyle(color: Colors.white)),
      onPressed: () {
        Get.offNamed("/ticketDetail/${registeredTicketId}");
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Prijava zadatka"),
      content: Text("Prijava zadatka uspješno izvršena!"),
      actions: [okButton, openTicketButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void openDocument(int index) {
    if (recordDocuments[index].documentExtension == 'png' ||
        recordDocuments[index].documentExtension == 'jpg' ||
        recordDocuments[index].documentExtension == 'jpeg') {
      showDialog(
          context: context,
          builder: (_) => Center(
              child: Container(
                  child: Image.memory(recordDocuments[index].documentData,
                      fit: BoxFit.scaleDown),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white)));
    } else {
      downloadFile(
          recordDocuments[index].documentData, recordDocuments[index].title);
    }
  }

  static void downloadFile(Uint8List bytes, String fileNameWithExtension) {
    final content = const Base64Encoder().convert(bytes);
    AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute("download", fileNameWithExtension)
      ..click();
  }
}
