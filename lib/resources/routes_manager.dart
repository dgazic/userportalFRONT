import 'package:get/get.dart';
import 'package:userportal/middlewares/_already_logged_in_route_guard_middleware.dart';
import 'package:userportal/middlewares/logged_in_route_guard_middleware.dart';
import 'package:userportal/screens/activation_account_page.dart';
import 'package:userportal/screens/administrator_account_settings.dart';
import 'package:userportal/screens/administrator_screen/list_of_users_page.dart';
import 'package:userportal/screens/home_page.dart';
import 'package:userportal/screens/list_of_all_tickets_page.dart';
import 'package:userportal/screens/administrator_screen/register_administrator_form.dart';
import 'package:userportal/screens/reset_password_page.dart';
import 'package:userportal/screens/session_expired_page.dart';
import 'package:userportal/screens/super_administrator_screen/add_administrator.dart';
import 'package:userportal/screens/super_administrator_screen/view_of_all_tickets_page.dart';
import 'package:userportal/screens/super_administrator_screen/view_of_all_users_page.dart';
import 'package:userportal/screens/ticket_detail_Page.dart';
import 'package:userportal/screens/ticket_registration_page.dart';

class Routes {
  static const String home = '/home';
  static const String adminScreen = '/adminScreen';
  static const String registerUserScreen = '/registerUser';
  static const String commonUserScreen = '/commonUser';
  static const String activationAccountScreen = '/activationAccount';
  static const String administratorAccountSettingsScreen =
      '/administratorAccountSettings';
  static const String resetPasswordScreen = '/resetPassword';
  static const String ticketDetailScreen = '/ticketDetail/:id';
  static const String listOfAllticketsScreen = '/ticketsList';
  static const String listOfAllUsersScreen = '/usersList';
  static const String ticketRegistrationScreen = '/ticketRegistration';
  static const String userDetailsScreen = '/userDetail';
  static const String superAdminRegisterUser = '/superAdminRegisterUser';
  static const String superAdminUsersList = '/superAdminUsersList';
  static const String superAdminTicketsList = '/superAdminTicketsList';
  static const String sessionExpiredScreen = '/sessionExpired';
}

class RoutesPages {
  static final pages = [
    GetPage(
        name: Routes.home,
        page: () => const HomePage(),
        middlewares: [AlreadyLoggedInRouteGuard(priority: 1)]),
    GetPage(
        name: Routes.registerUserScreen,
        page: () => RegisterScreen(),
        middlewares: [
          LoggedInRouteGuard(priority: 1),
          LoggedInRouteGuardAdmin(priority: 2)
        ]),
    GetPage(
        name: Routes.activationAccountScreen,
        page: () => const ActivationAccountScreen()),
    GetPage(
        name: Routes.administratorAccountSettingsScreen,
        page: () => const AdministratorAccountSettings(),
        middlewares: [
          LoggedInRouteGuard(priority: 1),
          LoggedInRouteGuardAdmin(priority: 2)
        ]),
    GetPage(
        name: Routes.resetPasswordScreen,
        page: () => const ResetPassowrdScreen()),
    GetPage(
        name: Routes.sessionExpiredScreen, page: () => SessionExpiredScreen()),
    GetPage(
        name: Routes.ticketDetailScreen,
        page: () => const TicketDetailScreen(),
        middlewares: [
          LoggedInRouteGuard(priority: 1),
          LoggedInRouteGuardTicketDetail(priority: 2)
        ]),
    GetPage(
        name: Routes.listOfAllticketsScreen,
        page: () => listOfAllTicketsScreen(),
        middlewares: [LoggedInRouteGuard(priority: 1)]),
    GetPage(
        name: Routes.listOfAllUsersScreen,
        page: () => const ListOfUsersScreen(),
        middlewares: [
          LoggedInRouteGuard(priority: 1),
          LoggedInRouteGuardAdmin(priority: 2)
        ]),
    GetPage(
        name: Routes.ticketRegistrationScreen,
        page: () => const TicketRegistrationScreen(),
        middlewares: [LoggedInRouteGuard(priority: 1)]),
    GetPage(
        name: Routes.superAdminRegisterUser,
        page: () => const AddHospitalAdministratorScreen(),
        middlewares: [
          LoggedInRouteGuard(priority: 1),
          LoggedInRouteGuardSuperAdmin(priority: 2)
        ]),
    GetPage(
        name: Routes.superAdminUsersList,
        page: () => const ListOfUsersSuperAdminScreen(),
        middlewares: [
          LoggedInRouteGuard(priority: 1),
          LoggedInRouteGuardSuperAdmin(priority: 2)
        ]),
    GetPage(
        name: Routes.superAdminTicketsList,
        page: () => ListOfAllTicketsSuperAdminScreen(),
        middlewares: [
          LoggedInRouteGuard(priority: 1),
          LoggedInRouteGuardSuperAdmin(priority: 2)
        ]),
  ];
}
