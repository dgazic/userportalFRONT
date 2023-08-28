import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userportal/models/ticket_model.dart';
import 'package:userportal/resources/EnumUserRoles.dart';
import 'package:userportal/services/network_handler/jwt_decoder.dart';

class TicketDataTableSource extends DataTableSource {
  final List<TicketsGetAllResponseModel> tickets;
  final Function(int) select;
  final BoxConstraints constraints;

  TicketDataTableSource(this.tickets, this.select, this.constraints);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => tickets.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    final String? userRoleId = jwtDecoder().getToken()['UserRoleId'];
    double width = constraints.maxWidth * 0.35;
    return DataRow(
        cells: [
          DataCell(ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width * 0.30),
            child: Row(children: [
              Container(
                  color: (tickets[index].status == 'Dodijeljen')
                      ? Colors.blue
                      : (tickets[index].status == 'Riješen' ||
                              tickets[index].status == 'Isporučen' ||
                              tickets[index].status ==
                                  'Isporuka sa slijedećom verzijom')
                          ? Colors.green
                          : (tickets[index].status == 'Razvoj')
                              ? Colors.orange
                              : (tickets[index].status == 'Analiza u tijeku')
                                  ? Colors.yellow
                                  : Colors.grey,
                  height: 8,
                  width: 8),
              SizedBox(width: 4),
              Expanded(child: Container(child: Text(tickets[index].status!))),
            ]),
          )),
          DataCell(ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 0.15),
              child: Text(tickets[index].id.toString()))),
          DataCell(ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 0.30),
              child: Text(tickets[index].abstract.toString(),
                  overflow: TextOverflow.ellipsis, maxLines: 3))),
          DataCell(ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 0.20),
              child: Text(tickets[index].type.toString()))),
          DataCell(ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 0.10),
              child: Text(tickets[index].product.toString()))),
          DataCell(ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 0.20),
              child: Text(tickets[index].domain.toString()))),
          DataCell(ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 0.15),
              child: Text(tickets[index].priority.toString()))),
          DataCell(ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width * 0.30),
              child: Text(tickets[index].enrollmentTime.toString()))),
          if (userRoleId == EnumUserRole.Administrator ||
              userRoleId == EnumUserRole.SuperAdministrator)
            DataCell(ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * 0.15),
                child: Text(
                    tickets[index].firstNameLastNameApplicant.toString()))),
          if (userRoleId == EnumUserRole.SuperAdministrator)
            DataCell(ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * 0.25),
                child: Text(tickets[index].hospitalName.toString()))),
        ],
        onSelectChanged: (_) {
          select(tickets[index].id!);
          Get.toNamed("/ticketDetail/${tickets[index].id}");
        });
  }
}
