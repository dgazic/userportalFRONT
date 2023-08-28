import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userportal/models/ticket_model.dart';
import 'package:userportal/providers/ticket_provider.dart';
import 'package:userportal/resources/EnumUserRoles.dart';
import 'package:userportal/resources/routes_manager.dart';
import 'package:userportal/services/network_handler/jwt_decoder.dart';

class LoggedInRouteGuard extends GetMiddleware {
  LoggedInRouteGuard({
    priority = 1,
  }) : super(priority: priority);

  @override
  RouteSettings? redirect(String? route) {
    final int? expirationTimeTmps = jwtDecoder().getToken()['exp'];
    final String? UserId = jwtDecoder().getToken()['UserId'];
    final String? UserRoleJwt = jwtDecoder().getToken()['UserRoleId'];
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    if (UserRoleJwt == null) {
      jwtDecoder().ClearUser();
      return const RouteSettings(name: Routes.home);
    }
    int userRoleId = int.parse(UserRoleJwt);

    return expirationTimeTmps != null &&
            UserId != null &&
            UserId.isNotEmpty &&
            expirationTimeTmps <= currentTime &&
            (userRoleId == 1 || userRoleId == 2 || userRoleId == 3)
        ? null
        : const RouteSettings(name: Routes.home);
  }
}

class LoggedInRouteGuardAdmin extends GetMiddleware {
  LoggedInRouteGuardAdmin({
    priority = 1,
  }) : super(priority: priority);

  @override
  RouteSettings? redirect(String? route) {
    final int? expirationTimeTmps = jwtDecoder().getToken()['exp'];
    final String? UserId = jwtDecoder().getToken()['UserId'];
    final String? UserRoleJwt = jwtDecoder().getToken()['UserRoleId'];
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    int userRoleId = int.parse(UserRoleJwt!);

    return expirationTimeTmps != null &&
            UserId != null &&
            UserId.isNotEmpty &&
            expirationTimeTmps <= currentTime &&
            userRoleId == 1
        ? null
        : const RouteSettings(name: Routes.ticketRegistrationScreen);
  }
}

class LoggedInRouteGuardSuperAdmin extends GetMiddleware {
  LoggedInRouteGuardSuperAdmin({
    priority = 1,
  }) : super(priority: priority);

  @override
  RouteSettings? redirect(String? route) {
    final int? expirationTimeTmps = jwtDecoder().getToken()['exp'];
    final String? UserId = jwtDecoder().getToken()['UserId'];
    final String? UserRoleJwt = jwtDecoder().getToken()['UserRoleId'];
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    int userRoleId = int.parse(UserRoleJwt!);

    return expirationTimeTmps != null &&
            UserId != null &&
            UserId.isNotEmpty &&
            expirationTimeTmps <= currentTime &&
            userRoleId == 3
        ? null
        : const RouteSettings(name: Routes.ticketRegistrationScreen);
  }
}

class LoggedInRouteGuardTicketDetail extends GetMiddleware {
  bool? isValidEnter;
  LoggedInRouteGuardTicketDetail({priority = 1}) : super(priority: priority);
  @override
  RouteSettings? redirect(String? route) {
    dynamic argumentsData = Get.parameters['id'];

    TicketProvider ticketProvider = TicketProvider();
    var fetchTicket = ticketProvider.GetTicket(int.parse(argumentsData));
    final int? expirationTimeTmps = jwtDecoder().getToken()['exp'];
    final String? UserId = jwtDecoder().getToken()['UserId'];
    final String? userRoleId = jwtDecoder().getToken()['UserRoleId'];
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    TicketEnterValidation(fetchTicket).then((isValidEnter) {
      if (expirationTimeTmps != null &&
          UserId != null &&
          UserId.isNotEmpty &&
          expirationTimeTmps <= currentTime &&
          isValidEnter) {
        return null;
      }
      final snackbar = SnackBar(
        content: Text('Nemate pristup zadatku br. ${argumentsData}'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackbar);

      if (userRoleId == EnumUserRole.SuperAdministrator)
        Get.offNamed(Routes.superAdminTicketsList);
      else
        Get.offNamed(Routes.listOfAllticketsScreen);
    });
  }

  Future<bool> TicketEnterValidation(
      Future<TicketsGetAllResponseModel> fetchTicket) async {
    String? ticketHospital = '';
    int? userTicketId;
    final String? userHospital = jwtDecoder().getToken()['UserHospital'];
    final String? userRoleId = jwtDecoder().getToken()['UserRoleId'];
    final String? UserHospitalId = jwtDecoder().getToken()['UserId'];

    await fetchTicket.then((value) {
      ticketHospital = value.hospitalName;
      userTicketId = value.UserId;
    });

    if ((ticketHospital == userHospital &&
            userRoleId == EnumUserRole.Administrator) ||
        (userRoleId == EnumUserRole.SuperAdministrator &&
            ticketHospital != null) ||
        (userTicketId == int.parse(UserHospitalId!))) {
      return isValidEnter = true;
    } else {
      return isValidEnter = false;
    }
  }
}
