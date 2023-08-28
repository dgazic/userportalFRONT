import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userportal/resources/EnumUserRoles.dart';
import 'package:userportal/resources/routes_manager.dart';
import 'package:userportal/services/network_handler/jwt_decoder.dart';
import 'package:userportal/widget/horizontalDivider.dart';
import 'package:userportal/widget/myText.dart';

class MyNavigationMenu extends StatefulWidget {
  const MyNavigationMenu({required this.smallScreen, Key? key})
      : super(key: key);
  final bool smallScreen;

  @override
  State<MyNavigationMenu> createState() => _MyNavigationMenuState();
}

class _MyNavigationMenuState extends State<MyNavigationMenu> {
  final ScrollController _scrollController = ScrollController();
  final String? userRoleId = jwtDecoder().getToken()['UserRoleId'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(new AssetImage('assets/images/Home_grey.png'), context);
    precacheImage(new AssetImage('assets/images/Home_white.png'), context);
    precacheImage(
        new AssetImage('assets/images/Pregled_zadataka_icon_off.png'), context);
    precacheImage(
        new AssetImage('assets/images/Pregled_zadataka_icon.png'), context);
    precacheImage(
        new AssetImage('assets/images/Administracija_icon_off.png'), context);
    precacheImage(
        new AssetImage('assets/images/Administracija_icon.png'), context);
    precacheImage(
        new AssetImage('assets/images/dodavanje_korisnika_grey.png'), context);
    precacheImage(
        new AssetImage('assets/images/dodavanje_korisnika_white.png'), context);
    precacheImage(
        new AssetImage('assets/images/korisnicki_profil_off.png'), context);
    precacheImage(
        new AssetImage('assets/images/korisnicki_profil_on.png'), context);
    precacheImage(
        new AssetImage('assets/images/prijavljivanje_zadataka_icon_off.png'),
        context);
    precacheImage(
        new AssetImage('assets/images/Prijavljivanje_zadataka_icon.png'),
        context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return SizedBox(
          width: (widget.smallScreen)
              ? MediaQuery.of(context).size.width * 0.20
              : MediaQuery.of(context).size.width * 0.16,
          child: Material(
            elevation: 4,
            color: Color.fromRGBO(104, 105, 109, 0.95),
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    (widget.smallScreen)
                        ? _buildHorizontalDividerXButton()
                        : _buildHorizontalDivider(),
                    if (userRoleId == EnumUserRole.Administrator ||
                        userRoleId == EnumUserRole.CommonUser)
                      _buildNavigationEntry(
                          label: 'PRIJAVLJIVANJE ZADATAKA',
                          route: Routes.ticketRegistrationScreen,
                          assetImageOff: AssetImage(
                              "assets/images/prijavljivanje_zadataka_icon_off.png"),
                          assetImageOn: AssetImage(
                              "assets/images/Prijavljivanje_zadataka_icon.png")),
                    if (userRoleId == EnumUserRole.Administrator ||
                        userRoleId == EnumUserRole.CommonUser)
                      _buildNavigationEntry(
                          label: 'PREGLED ZADATAKA',
                          route: Routes.listOfAllticketsScreen,
                          subRoutes: [
                            Routes.ticketDetailScreen,
                          ],
                          assetImageOff: AssetImage(
                              "assets/images/Pregled_zadataka_icon_off.png"),
                          assetImageOn: AssetImage(
                              "assets/images/Pregled_zadataka_icon.png")),
                    if (userRoleId == EnumUserRole.Administrator)
                      _buildNavigationEntry(
                          label: 'ADMINISTRACIJA KORISNIKA',
                          route: Routes.listOfAllUsersScreen,
                          assetImageOff: AssetImage(
                              "assets/images/Administracija_icon_off.png"),
                          assetImageOn: AssetImage(
                              "assets/images/Administracija_icon.png")),
                    if (userRoleId == EnumUserRole.Administrator)
                      _buildNavigationEntry(
                          label: 'DODAVANJE NOVOG KORISNIKA',
                          route: Routes.registerUserScreen,
                          assetImageOff: AssetImage(
                              "assets/images/dodavanje_korisnika_grey.png"),
                          assetImageOn: AssetImage(
                              "assets/images/dodavanje_korisnika_white.png")),
                    if (userRoleId == EnumUserRole.SuperAdministrator)
                      _buildNavigationEntry(
                          label: 'DODAVANJE ADMINISTRATORA KORISNIKA',
                          route: Routes.superAdminRegisterUser,
                          assetImageOff: AssetImage(
                              "assets/images/dodavanje_korisnika_grey.png"),
                          assetImageOn: AssetImage(
                              "assets/images/dodavanje_korisnika_white.png")),
                    if (userRoleId == EnumUserRole.SuperAdministrator)
                      _buildNavigationEntry(
                          label: 'ADMINISTRACIJA KORISNIKA',
                          route: Routes.superAdminUsersList,
                          assetImageOff: AssetImage(
                              "assets/images/Administracija_icon_off.png"),
                          assetImageOn: AssetImage(
                              "assets/images/Administracija_icon.png")),
                    if (userRoleId == EnumUserRole.SuperAdministrator)
                      _buildNavigationEntry(
                          label: 'PREGLED ZADATAKA',
                          route: Routes.superAdminTicketsList,
                          assetImageOff: AssetImage(
                              "assets/images/Pregled_zadataka_icon_off.png"),
                          assetImageOn: AssetImage(
                              "assets/images/Pregled_zadataka_icon.png")),
                  ],
                ),
                if (widget.smallScreen) _buildCloseButton()
              ],
            ),
          ),
        );
      },
    );
  }

  SingleChildRenderObjectWidget _buildHorizontalDivider() =>
      const SliverToBoxAdapter(
          child:
              MyHorizontalDivider(padding: EdgeInsets.symmetric(vertical: 8)));

  SingleChildRenderObjectWidget _buildHorizontalDividerXButton() =>
      const SliverToBoxAdapter(
          child:
              MyHorizontalDivider(padding: EdgeInsets.symmetric(vertical: 25)));

  SingleChildRenderObjectWidget _buildNavigationEntry(
          {required String label,
          required String route,
          required AssetImage assetImageOff,
          required AssetImage assetImageOn,
          List<String> subRoutes = const []}) =>
      SliverToBoxAdapter(
          child: _NavigationEntry(
              label: label,
              route: route,
              subRoutes: subRoutes,
              assetImageOff: assetImageOff,
              assetImageOn: assetImageOn));

  Widget _buildCloseButton() {
    return IconButton(
        onPressed: () => Scaffold.of(context).closeDrawer(),
        icon: const Icon(Icons.close));
  }
}

class _NavigationEntry extends StatelessWidget {
  const _NavigationEntry(
      {Key? key,
      required this.label,
      required this.route,
      this.subRoutes = const [],
      required this.assetImageOff,
      required this.assetImageOn})
      : super(key: key);
  final String label;
  final String route;
  final List<String> subRoutes;
  final AssetImage assetImageOff;
  final AssetImage assetImageOn;

  @override
  Widget build(BuildContext context) {
    final String currentRoute = Get.currentRoute;
    final bool onThisRoute =
        currentRoute == route || subRoutes.contains(currentRoute);

    return GestureDetector(
      onTap: () {
        if (Get.currentRoute != route) {
          Get.deleteAll();
          Get.toNamed(route);
        }
      },
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 30.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: onThisRoute ? assetImageOn : assetImageOff,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(label,
                        fontSize: 16,
                        color: onThisRoute
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        fontWeight:
                            onThisRoute ? FontWeight.w700 : FontWeight.w400,
                        maxLines: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
