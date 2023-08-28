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
import 'package:userportal/widget/myScaffold.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({Key? key}) : super(key: key);

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  dynamic argumentsData;
  late var ticketProvider;
  TicketsGetAllResponseModel ticketModel = TicketsGetAllResponseModel();
  late Future<TicketsGetAllResponseModel> ticketFuture;

  @override
  void initState() {
    super.initState();
    TicketProvider ticketProvider = TicketProvider();
    argumentsData = Get.parameters['id'];
    var fetchTicket = ticketProvider.GetTicket(int.parse(argumentsData));
    ticketFuture = fetchTicket;
    ticketModel = TicketsGetAllResponseModel();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      child: FutureBuilder<TicketsGetAllResponseModel>(
        future: ticketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var ticket = snapshot.data;
            if (ticket == null || ticket.id == null) {
              return Container();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DataView(
                  id: ticket.id,
                  abstract: ticket.abstract,
                  description: ticket.description,
                  status: ticket.status,
                  product: ticket.product,
                  domain: ticket.domain,
                  category: ticket.type,
                  enrollmentTime: ticket.enrollmentTime,
                  priority: ticket.priority,
                  ticketHandler: ticket.ticketHandler,
                ),
              ],
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DataView extends StatefulWidget {
  DataView(
      {Key? key,
      this.abstract,
      this.description,
      this.status,
      this.id,
      this.product,
      this.domain,
      this.category,
      this.enrollmentTime,
      this.priority,
      this.ticketHandler})
      : super(key: key);

  final abstract;
  final description;
  late String? status;
  final id;
  final product;
  final domain;
  final String? category;
  final enrollmentTime;
  late String? priority;
  final ticketHandler;

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  late TextEditingController? abstractController = TextEditingController();
  late TextEditingController? desctiptionController = TextEditingController();
  final taskPriorityController = TextEditingController();
  late TicketChangePriorityRequestModel requestModel;
  TicketProvider ticketProvider = TicketProvider();
  TicketsGetAllResponseModel? ticket;

  @override
  void initState() {
    super.initState();
    requestModel = TicketChangePriorityRequestModel();
  }

  String dropdownPriority = 'Normalni';
  var taskPriority = [
    'Normalni',
    'Ništa',
    'Niski',
    'Visoki',
    'Hitno',
    'Trenutno'
  ];
  bool? ticketStatusClosed = false;
  String? ticketPriority;

  @override
  void dispose() {
    super.dispose();
    taskPriorityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Column(children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15),
                                child: Container(
                                  child: Text('Broj zadatka',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          Expanded(
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child: SelectableText(widget.id.toString()),
                            ),
                          )),
                        ])
                      ],
                    ),
                    Container(child: Divider()),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15),
                                child: Container(
                                  child: Text('Prioritet',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          Expanded(
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child: SelectableText(widget.priority.toString()),
                            ),
                          )),
                          Expanded(
                              child: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, right: 15),
                              child: (widget.status != 'Zatvoren')
                                  ? ElevatedButton.icon(
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
                                                                'Promjena prioriteta')),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: CircleAvatar(
                                                              radius: 14.0,
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      300],
                                                              child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                content: Row(
                                                  children: [
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                        child:
                                                            dropdownPriorityChange(
                                                                context)),
                                                    SizedBox(width: 5),
                                                    Container(
                                                      child:
                                                          ElevatedButton.icon(
                                                              onPressed:
                                                                  () async {
                                                                Get.back();
                                                                await changeTicketPriority();
                                                                widget.priority =
                                                                    taskPriorityController
                                                                        .text;
                                                                setState(() {});
                                                              },
                                                              icon: Icon(Icons
                                                                  .change_circle_outlined),
                                                              label: Text(
                                                                  "Potvrdi")),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.change_circle),
                                      label:
                                          Text('Promjena prioriteta zadatka'))
                                  : Container(),
                            ),
                          )),
                        ])
                      ],
                    ),
                    Container(child: Divider()),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15),
                                child: Container(
                                  child: Text('Projekt',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          Expanded(
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child: SelectableText(widget.product),
                            ),
                          )),
                        ])
                      ],
                    ),
                    Container(child: Divider()),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15),
                                child: Container(
                                  child: Text('Domena',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          Expanded(
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child: SelectableText(widget.domain),
                            ),
                          )),
                        ])
                      ],
                    ),
                    Container(child: Divider()),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15),
                                child: Container(
                                  child: Text('Dodijeljen (korisniku)',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          Expanded(
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child: SelectableText(widget.ticketHandler),
                            ),
                          )),
                        ])
                      ],
                    ),
                    Container(child: Divider()),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15),
                                child: Container(
                                  child: Text('Kategorija',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          Expanded(
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child: SelectableText(widget.category!),
                            ),
                          )),
                        ])
                      ],
                    ),
                    Container(child: Divider()),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 15),
                                child: Container(
                                  child: Text('Datum i vrijeme prijave',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          Expanded(
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15),
                              child: SelectableText(widget.enrollmentTime),
                            ),
                          )),
                        ])
                      ],
                    ),
                    Container(child: Divider()),
                    (widget.status != 'Zatvoren' &&
                            widget.status == 'Dodijeljen')
                        ? (ticketStatusClosed != true)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      child: ElevatedButton.icon(
                                          onPressed: () async {
                                            showAlertDialog(context);
                                          },
                                          icon: Icon(
                                              Icons.close_fullscreen_rounded),
                                          label: Text("Zatvori zadatak"))),
                                  SizedBox(width: 5),
                                  Tooltip(
                                      message:
                                          'Zadatak se može zatvoriti sve dok nije prešao u status - Analiza u tijeku',
                                      child: Container(
                                          child: Icon(Icons.info,
                                              color: Colors.grey)))
                                ],
                              )
                            : Container()
                        : Container()
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
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            child: Text('Status zadatka',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                    (widget.category == 'Podrška')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 170,
                                  height: 170,
                                  child: (widget.status == 'Dodijeljen')
                                      ? Tooltip(
                                          message:
                                              'Zadatak je trenutno u statusu Dodijeljen',
                                          child: Container(
                                              child: SvgPicture.asset(
                                                  'assets/images/Dodijeljen_ON.svg')))
                                      : Tooltip(
                                          message:
                                              'Zadatak je trenutno u statusu Dodijeljen',
                                          child: Container(
                                              child: SvgPicture.asset(
                                                  'assets/images/Dodijeljen_Off.svg')))),
                              Container(
                                  width: 170,
                                  height: 170,
                                  child: (widget.status == 'Analiza u tijeku')
                                      ? Tooltip(
                                          message:
                                              'Zadatak je trenutno u statusu Analiza u tijeku',
                                          child: Container(
                                              child: SvgPicture.asset(
                                                  'assets/images/Analiza_On.svg')))
                                      : Tooltip(
                                          message:
                                              'Zadatak je trenutno u statusu Analiza u tijeku',
                                          child: Container(
                                              child: SvgPicture.asset(
                                                  'assets/images/Analiza_Off.svg')))),
                              Column(
                                children: [
                                  Container(
                                      width: 170,
                                      height: 170,
                                      child: (widget.status == 'Riješen')
                                          ? Tooltip(
                                              message:
                                                  'Zadatak je trenutno u statusu Riješen',
                                              child: Container(
                                                  child: SvgPicture.asset(
                                                      'assets/images/Rijesen_On.svg')))
                                          : Tooltip(
                                              message:
                                                  'Zadatak je trenutno u statusu Riješen',
                                              child: Container(
                                                  child: SvgPicture.asset(
                                                      'assets/images/Rijesen_Off.svg')))),
                                  Container(
                                      width: 170,
                                      height: 170,
                                      child: (widget.status == 'Zatvoren')
                                          ? Tooltip(
                                              message:
                                                  'Zadatak je trenutno u statusu Zatvoren',
                                              child: Container(
                                                  child: SvgPicture.asset(
                                                      'assets/images/Zatvoren_On.svg')))
                                          : Tooltip(
                                              message:
                                                  'Zadatak je trenutno u statusu Zatvoren',
                                              child: Container(
                                                  child: SvgPicture.asset(
                                                      'assets/images/Zatvoren_Off.svg')))),
                                ],
                              ),
                            ],
                          )
                        : (widget.category == 'Novi zahtjev' ||
                                widget.category == 'Greška')
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 170,
                                      height: 170,
                                      child: (widget.status == 'Dodijeljen')
                                          ? Tooltip(
                                              message:
                                                  'Zadatak je trenutno u statusu Dodijeljen',
                                              child: Container(
                                                  child: SvgPicture.asset(
                                                      'assets/images/Dodijeljen_ON.svg')))
                                          : Tooltip(
                                              message:
                                                  'Zadatak je trenutno u statusu Dodijeljen',
                                              child: Container(
                                                  child: SvgPicture.asset(
                                                      'assets/images/Dodijeljen_Off.svg')))),
                                  Container(
                                      width: 170,
                                      height: 170,
                                      child: (widget.status ==
                                              'Analiza u tijeku')
                                          ? Tooltip(
                                              message:
                                                  'Zadatak je trenutno u statusu Analiza u tijeku',
                                              child: Container(
                                                  child: SvgPicture.asset(
                                                      'assets/images/Analiza_On.svg')))
                                          : Tooltip(
                                              message:
                                                  'Zadatak je trenutno u statusu Analiza u tijeku',
                                              child: Container(
                                                  child: SvgPicture.asset(
                                                      'assets/images/Analiza_Off.svg')))),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 170,
                                              height: 170,
                                              child: (widget.status ==
                                                      'Riješen')
                                                  ? Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Riješen',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Rijesen_On.svg')))
                                                  : Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Riješen',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Rijesen_Off.svg')))),
                                          Container(
                                              width: 170,
                                              height: 170,
                                              child: (widget.status ==
                                                      'Zatvoren')
                                                  ? Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Zatvoren',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Zatvoren_On.svg')))
                                                  : Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Zatvoren',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Zatvoren_Off.svg'))))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              width: 170,
                                              height: 170,
                                              child: (widget.status == 'Razvoj')
                                                  ? Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Razvoj',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Razvoj_On.svg')))
                                                  : Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Razvoj',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Razvoj_off.svg')))),
                                          Container(
                                              width: 170,
                                              height: 170,
                                              child: (widget.status ==
                                                      'Isporuka sa slijedećom verzijom')
                                                  ? Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Isporuka sa slijedećom verzijom',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Isporuka_On.svg')))
                                                  : Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Isporuka sa slijedećom verzijom',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Isporuka_off.svg')))),
                                          Container(
                                              width: 170,
                                              height: 170,
                                              child: (widget.status ==
                                                      'Isporučen')
                                                  ? Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Isporučen',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Isporucen_On.svg')))
                                                  : Tooltip(
                                                      message:
                                                          'Zadatak je trenutno u statusu Isporučen',
                                                      child: Container(
                                                          child: SvgPicture.asset(
                                                              'assets/images/Isporucen_Off.svg')))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                      child: Container(
                        child: Text('Sažetak',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: _buildAbstract(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                      child: Container(
                        child: Text('Opis',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: _buildDescription(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                      child: Container(
                        child: Text('Prilozi',
                            style: TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Stack(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  child:
                                                      Text('Prikaz priloga')),
                                              MouseRegion(
                                                cursor:
                                                    SystemMouseCursors.click,
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
                                      content: showAttachmentList(widget.id),
                                    );
                                  });
                            },
                            icon: Icon(Icons.attachment),
                            label: Text("Otvori priloge")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbstract() {
    return TextFormField(
      controller: abstractController!..text = '${widget.abstract}',
      readOnly: true,
      minLines: 2,
      maxLines: 3,
      decoration: InputDecoration(
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
        contentPadding: const EdgeInsets.all(15.0),
      ),
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      controller: desctiptionController!..text = '${widget.description}',
      readOnly: true,
      minLines: 15,
      maxLines: 25,
      decoration: InputDecoration(
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
        contentPadding: const EdgeInsets.all(15.0),
      ),
    );
  }

  Widget showAttachmentList(int id) {
    TicketProvider ticketProvider = TicketProvider();
    var fetchAllTicketAttachments = ticketProvider.GetTicketAttachment(id);
    return Container(
      height: 400.0,
      width: 400.0,
      child: Center(
          child: FutureBuilder<List<TicketAttachmentModel>>(
        future: fetchAllTicketAttachments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            var ticketAttachment = snapshot.data;
            return buildTicketAttachments(ticketAttachment!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      )),
    );
  }

  Widget buildTicketAttachments(List<TicketAttachmentModel> ticketAttachment) {
    return Container(
      height: 400.0,
      width: 400.0,
      child: (ticketAttachment.length != 0)
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: ticketAttachment.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => openDocument(index, ticketAttachment),
                  child: HoverAnimatedContainer(
                    hoverColor: Colors.grey[200],
                    child: ListTile(
                      leading: (ticketAttachment[index].documentExtension ==
                                  '.png' ||
                              ticketAttachment[index].documentExtension ==
                                  '.jpeg' ||
                              ticketAttachment[index].documentExtension ==
                                  '.jpg')
                          ? Icon(Icons.picture_in_picture)
                          : (ticketAttachment[index].documentExtension ==
                                  '.pdf')
                              ? Icon(Icons.picture_as_pdf)
                              : (ticketAttachment[index].documentExtension ==
                                      '.doc')
                                  ? Icon(Icons.wordpress)
                                  : Icon(Icons.media_bluetooth_off),
                      title: Text(ticketAttachment[index].title),
                    ),
                  ),
                );
              },
            )
          : Container(child: Center(child: Text("Nema odabranih priloga"))),
    );
  }

  void openDocument(int index, List<TicketAttachmentModel> ticketAttachment) {
    if (ticketAttachment[index].documentExtension == '.png' ||
        ticketAttachment[index].documentExtension == '.jpg' ||
        ticketAttachment[index].documentExtension == '.jpeg') {
      showDialog(
          context: context,
          builder: (_) => Center(
              // Aligns the container to center
              child: Container(
                  child: Image.memory(ticketAttachment[index].documentData,
                      fit: BoxFit.scaleDown),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white)));
    } else {
      downloadFile(
          ticketAttachment[index].documentData, ticketAttachment[index].title);
    }
  }

  static void downloadFile(Uint8List bytes, String fileNameWithExtension) {
    final content = const Base64Encoder().convert(bytes);
    AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$content")
      ..setAttribute("download", fileNameWithExtension)
      ..click();
  }

  closeTicket(int id) async {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    var responseData = await ticketProvider.CloseTicket(id);
    if (responseData.success == true)
      showAlertDialogSuccess(context);
    else
      showAlertDialogFailture(context);
  }

  showAlertDialogSuccess(BuildContext context) {
    Widget okButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text("U redu", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Zatvaranje zadatka"),
      content: Text("Zatvaranje zadatka uspješno izvršeno!"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogFailture(BuildContext context) {
    Widget okButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text("U redu", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Zatvaranje zadatka"),
      content: Text(
          "Zatvaranje zadatka nespješno izvršeno, vaš zadatak je trenutno u obradi!"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Odustani"),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text("Zatvori zadatak", style: TextStyle(color: Colors.white)),
      onPressed: () async {
        Get.back();
        await closeTicket(widget.id);
        ticketStatusClosed = true;
        widget.status = 'Zatvoren';
        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Upozorenje!"),
      content: Text(
          "Želite li zatvoriti zadatak br.${widget.id} - ${widget.abstract} "),
      actions: [
        cancelButton,
        continueButton,
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

  Widget dropdownPriorityChange(BuildContext context) {
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
      value: widget.priority,
      icon: const Icon(Icons.keyboard_arrow_down),

      items: taskPriority.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownPriority = newValue!;
        });
      },
    );
  }

  changeTicketPriority() async {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    ticketPriorityMapping();
    requestModel.id = widget.id;
    requestModel.priority = taskPriorityController.text;
    var responseData = await ticketProvider.ChangeTicketPriority(requestModel);
    if (responseData.success == true)
      showAlertDialogChangePrioritySuccess(context);
    else
      showAlertDialogFailture(context);
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

  showAlertDialogChangePrioritySuccess(BuildContext context) {
    Widget okButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text("U redu", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Promjena prioriteta"),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Promjena prioriteta zadatka uspješno izvršena!'),
            TextSpan(text: '\n'),
            TextSpan(text: 'Iz prioriteta '),
            TextSpan(
                text: '${widget.priority} ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'u '),
            TextSpan(
                text: '${taskPriorityController.text}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogChangePriorityFailture(BuildContext context) {
    Widget okButton = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      child: Text("U redu", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Promjena prioriteta"),
      content: Text(
          "Promjena prioriteta zadatka nespješno izvršena, vaš zadatak je trenutno u obradi!"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
