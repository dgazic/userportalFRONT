import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userportal/resources/EnumUserRoles.dart';
import 'package:userportal/resources/routes_manager.dart';
import 'package:userportal/services/network_handler/jwt_decoder.dart';

class AlreadyLoggedInRouteGuard extends GetMiddleware {
  AlreadyLoggedInRouteGuard({
    priority = 1,
  }) : super(priority: priority);

  @override
  RouteSettings? redirect(String? route) {
    final int? expirationTimeTmps = jwtDecoder().getToken()['exp'];
    if (expirationTimeTmps == null) return null;

    final String? UserId = jwtDecoder().getToken()['UserId'];
    final String? UserRoleJwt = jwtDecoder().getToken()['UserRoleId'];
    int userRoleId = int.parse(UserRoleJwt!);
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    return expirationTimeTmps != null &&
            UserId != null &&
            UserId.isNotEmpty &&
            expirationTimeTmps <= currentTime &&
            (userRoleId == 1 || userRoleId == 2 || userRoleId == 3)
        ? (UserRoleJwt == EnumUserRole.Administrator ||
                UserRoleJwt == EnumUserRole.CommonUser)
            ? const RouteSettings(name: Routes.listOfAllticketsScreen)
            : const RouteSettings(name: Routes.superAdminTicketsList)
        : null;
  }
}
