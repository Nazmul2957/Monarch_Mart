// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';

class AppBottomNavigation extends StatelessWidget {
  late AppScreen screen;
  @override
  Widget build(BuildContext context) {
    screen = AppScreen(context);
    return Consumer<AppProvider>(
      builder: (context, provider, child) => BottomNavigationBar(
          selectedItemColor: AppColor.primary,
          unselectedItemColor: AppColor.secondary,
          iconSize: screen.height * 3.5,
          currentIndex: provider.currentIndex,
          showUnselectedLabels: true,
          onTap: (index) {
            if (provider.accessToken == null) {
              if (index >= 3) {
                Navigator.pushNamed(context, AppRoute.login);
              } else {
                provider.bottomNavigation(index);
                switch (index) {
                  case 0:
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoute.home, (route) => false);
                    break;
                  case 1:
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoute.category, (route) => false,
                        arguments:
                            ScreenArguments(data: {"url": "/categories"}));
                    break;
                  default:
                    Navigator.pushNamed(context, AppRoute.filteredProduct,
                        arguments: ScreenArguments(
                            data: {"category": AppString.Product}));
                    break;
                }
              }
            } else {
              provider.bottomNavigation(index);
              switch (index) {
                case 0:
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoute.home, (route) => false);
                  break;
                case 1:
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoute.category, (route) => false,
                      arguments: ScreenArguments(data: {"url": "/categories"}));
                  break;
                case 2:
                  Navigator.pushNamed(context, AppRoute.filteredProduct,
                      arguments: ScreenArguments(
                          data: {"category": AppString.Product}));
                  break;
                case 3:
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoute.cart, (route) => false);
                  break;

                default:
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoute.profile, (route) => false);
                  break;
              }
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.grid_view_outlined,
                ),
                label: "Categories"),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront),
              label: "Product",
            ),
            BottomNavigationBarItem(
                icon: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Icon(Icons.shopping_cart_outlined),
                    Positioned(
                      bottom: screen.height * 0.75,
                      left: screen.width * 3.5,
                      child: provider.totalCartProducts != 0
                          ? Container(
                              padding: EdgeInsets.all(screen.width),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.primary),
                              child: Text(
                                provider.totalCartProducts.toString(),
                                style: TextStyle(
                                    fontSize: screen.height * 1.6,
                                    color: Colors.white),
                              ))
                          : Container(),
                    )
                  ],
                ),
                label: "Cart"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: "Profile"),
          ]),
    );
  }
}
