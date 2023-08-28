import 'package:userportal/models/ticket_attachment_model.dart';

class TicketRegistrationResponseModel {
  final String? error;
  bool? success;
  int? ticketId;

  TicketRegistrationResponseModel({this.error, this.success, this.ticketId});

  factory TicketRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketRegistrationResponseModel(
        error: json["error"],
        success: json["success"],
        ticketId: json["ticketId"]);
  }
}

class TicketRegistrationRequestModel {
  String? abstract;
  String? description;
  String? ticketType;
  String? product;
  String? domain;
  String? priority;
  List<TicketAttachmentModel>? recordDocuments = <TicketAttachmentModel>[];

  TicketRegistrationRequestModel(
      {this.abstract,
      this.description,
      this.ticketType,
      this.product,
      this.domain,
      this.priority,
      this.recordDocuments});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Type': ticketType!.trim(),
      'Abstract': abstract!.trim(),
      'Description': description!.trim(),
      'Product': product!.trim(),
      'Domain': domain,
      'Priority': priority,
      'Attachments':
          TicketAttachmentModelMapper.listToJson(this.recordDocuments!),
    };

    return map;
  }
}

class TicketsGetFilterDateRequestModel {
  DateTime? enrollmentTimeDateFrom;
  DateTime? enrollmentTimeDateTo;

  TicketsGetFilterDateRequestModel(
      {this.enrollmentTimeDateFrom, this.enrollmentTimeDateTo});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'EnrollmentTimeDateFrom': enrollmentTimeDateFrom!,
      'EnrollmentTimeDateTo': enrollmentTimeDateTo!,
    };
    return map;
  }
}

class TicketsGetAllResponseModel {
  int? id;
  String? abstract;
  String? description;
  String? type;
  String? enrollmentTime;
  String? status;
  String? product;
  String? domain;
  int? UserId;
  String? firstNameLastNameApplicant;
  String? priority;
  String? hospitalName;
  String? ticketHandler;

  TicketsGetAllResponseModel(
      {this.id,
      this.abstract,
      this.description,
      this.enrollmentTime,
      this.type,
      this.status,
      this.product,
      this.domain,
      this.UserId,
      this.firstNameLastNameApplicant,
      this.priority,
      this.hospitalName,
      this.ticketHandler});

  factory TicketsGetAllResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketsGetAllResponseModel(
        id: json["id"],
        abstract: json["abstract"],
        description: json["description"],
        enrollmentTime: json["enrollmentTime"],
        type: json["type"],
        status: json["status"],
        product: json["product"],
        domain: json["domain"],
        UserId: json["userId"],
        firstNameLastNameApplicant: json["firstNameLastNameApplicant"],
        priority: json['priority'],
        hospitalName: json['hospitalName'],
        ticketHandler: json['ticketHandler']);
  }
}

class TicketChangePriorityRequestModel {
  String? priority;
  int? id;

  TicketChangePriorityRequestModel({this.priority, this.id});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'Priority': priority!,
      'Id': id!,
    };
    return map;
  }
}
