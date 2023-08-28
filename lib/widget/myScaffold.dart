import 'package:flutter/material.dart';
import 'package:userportal/widget/NavigationMenu.dart';
import 'package:userportal/widget/myAppBar.dart';


class MyScaffold extends StatelessWidget {
  const MyScaffold({
    Key? key,
    required this.child,
    this.showNavigationMenu = true,
    this.bottomFloatingWidget,
  }) : super(key: key);
  final Widget child;
  final bool showNavigationMenu;
  final Widget? bottomFloatingWidget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final smallScreen = constraints.maxWidth <= 1492;
        return Scaffold(
          appBar: MyAppBar(smallScreen: smallScreen,
        ),
          drawer:
              smallScreen ? MyNavigationMenu(smallScreen: smallScreen) : null,
          drawerEnableOpenDragGesture: false,
          body: Row(
            children: [
              if (showNavigationMenu && !smallScreen)
                MyNavigationMenu(smallScreen: smallScreen),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: child,
                    ),
                    if (bottomFloatingWidget != null) bottomFloatingWidget!
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
