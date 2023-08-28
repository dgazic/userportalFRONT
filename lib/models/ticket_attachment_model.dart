import 'dart:convert';
import 'dart:typed_data';

class TicketAttachmentModel {
  String title = '';
  String documentExtension = '';
  Uint8List documentData = Uint8List(0);
  late int size;

  TicketAttachmentModel(
      {required this.documentData,
      required this.documentExtension,
      required this.size,
      required this.title});

  factory TicketAttachmentModel.fromJson(Map<String, dynamic> json) {
    String title = json['title'];
    String documentExtension = json['documentExtension'];
    Uint8List documentData = Base64Decoder().convert(json['documentData']);
    int size = json['size'];
    return TicketAttachmentModel(
        documentData: documentData,
        documentExtension: documentExtension,
        size: size,
        title: title);
  }

  TicketAttachmentModel.empty();
}

class TicketAttachmentModelMapper {
  static Map<String, dynamic> toJson(TicketAttachmentModel model) =>
      <String, dynamic>{
        "title": model.title,
        "documentExtension": model.documentExtension,
        "documentData": const Base64Encoder().convert(model.documentData),
        "size": model.size
      };

  static List<dynamic> listToJson(List<TicketAttachmentModel> list) {
    return List<dynamic>.from(list.map((x) => toJson(x)));
  }
}
