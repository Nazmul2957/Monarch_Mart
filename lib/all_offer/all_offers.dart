// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/all_offer_response.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_drawer.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:provider/provider.dart';

import 'all_offer_provider.dart';

class AllOffer extends StatelessWidget {
  bool isNotFromBottomNavigation;
  AllOffer({this.isNotFromBottomNavigation = true});
  late double width, height;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late AllOfferProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AllOfferProvider>(context, listen: false);
    var screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    provider.getFlashDealProduct();
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: isNotFromBottomNavigation
            ? Myappbar(context).appbar(
                isFromHome: false,
                title: "Offers",
                ontap: () {
                  scaffoldKey.currentState?.openDrawer();
                })
            : Myappbar(context).appBarAllOffer(
                title: "All Offers",
                isNotFromNavigation: isNotFromBottomNavigation),
        drawer: isNotFromBottomNavigation
            ? AppDrawer()
            : Container(color: Colors.transparent),
        body: RefreshIndicator(onRefresh: () async {
          provider.getFlashDealProduct();
        }, child: Consumer<AllOfferProvider>(builder: (context, ob, child) {
          if (ob.response != null) {
            return ListView.builder(
              padding:
                  EdgeInsets.symmetric(horizontal: width * 5, vertical: height),
              itemCount: ob.response!.data!.length,
              itemBuilder: (context, index) =>
                  singleitemListView(ob.response, index),
            );
          } else {
            return shimerListView();
          }
        })),
        bottomNavigationBar: AppBottomNavigation(),
      ),
    );
  }

  Widget singleitemListView(AllOfferResponse? response, int index) {
    DateTime end = provider.convertTimeStampToDateTime(
        int.parse(response!.data![index].date.toString()));
    DateTime now = DateTime.now();
    int diff = end.difference(now).inMilliseconds;
    int endTime = diff + now.millisecondsSinceEpoch;
    void onEnd() {}
    provider.timerControllerList
        .add(CountdownTimerController(endTime: endTime, onEnd: onEnd));
    return Padding(
        padding: EdgeInsets.only(bottom: height * 1.25),
        child: CountdownTimer(
          controller: provider.timerControllerList[index],
          widgetBuilder: (context, time) {
            return Container(
              padding:
                  EdgeInsets.symmetric(horizontal: width, vertical: height),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (time == null) {
                        print("offer ended");
                      } else {
                        Navigator.pushNamed(context, AppRoute.product,
                            arguments: ScreenArguments(data: {
                              "numberofChildren": 0,
                              "subcategoryUrl": "",
                              "url": "/flash-deal-products/" +
                                  response.data![index].id.toString(),
                              "category": response.data![index].title.toString()
                            }));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: height * 13,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(height),
                        child: CachedImage(
                          imageUrl:
                              response.data![index].banner.toString(),
                          boxFit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: height * 1.5, top: height * 1.5),
                    child: Text(
                      response.data![index].title.toString(),
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: height * 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: time == null
                        ? Text(
                            "Ended",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: height * 1.6,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : timeDisplay(time),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget timeDisplay(CurrentRemainingTime time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        singleTimeBlock(
            provider.timeText(time.days.toString(), defaultLength: 3)),
        timeSpacer(),
        singleTimeBlock(
            provider.timeText(time.hours.toString(), defaultLength: 2)),
        timeSpacer(),
        singleTimeBlock(
            provider.timeText(time.min.toString(), defaultLength: 2)),
        timeSpacer(),
        singleTimeBlock(
            provider.timeText(time.sec.toString(), defaultLength: 2)),
      ],
    );
  }

  Widget singleTimeBlock(String s) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: width),
        child: Text(
          s,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: height * 2.2,
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ));
  }

  Widget timeSpacer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width),
      child: Text(
        ":",
        style: TextStyle(
          color: Colors.black87,
          fontSize: height * 2.1,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget shimerListView() {
    return ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.symmetric(horizontal: width * 5),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: height * 1.25),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: width / 5,
            ),
            borderRadius: BorderRadius.circular(height),
          ),
          child: Column(
            children: [
              AppShimer(height: height * 13, width: double.infinity),
              SizedBox(height: height),
              AppShimer(height: height * 3.5, width: width * 30),
              SizedBox(height: height),
              AppShimer(height: height * 3.5, width: width * 50),
            ],
          ),
        ),
      ),
    );
  }
}
