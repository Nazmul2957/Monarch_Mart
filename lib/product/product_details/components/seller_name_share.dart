// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_components/app_font.dart';
import 'package:monarch_mart/app_components/app_route.dart';
import 'package:monarch_mart/app_models/screen_aguments.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';

import '../product_details_provider.dart';

class SellerName extends StatelessWidget {
  ProductDetailsProvider presenter;

  SellerName({required this.presenter});

  late BuildContext context;
  late double width, height;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var screen = AppScreen(context);
    width = screen.width;
    height = screen.height;
    return Consumer<ProductDetailsProvider>(
      builder: (context, ob, child) {
        if (ob.response != null) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: height),
              decoration:
                  BoxDecoration(color: AppColor.lightRed.withOpacity(0.1)),
              child: sellerName());
        } else {
          return AppShimer(width: width * 90, height: height * 8);
        }
      },
    );
  }

  Widget sellerName() {
    return Container(
      width: width * 90,
      padding:
          EdgeInsets.symmetric(vertical: height / 2, horizontal: width * 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          sellerNameLogo(presenter.response!.data![0].shopLogo.toString(),
              presenter.response!.data![0].shopName.toString()),
          shareOption()
        ],
      ),
    );
  }

  Widget sellerNameLogo(String url, String sellerName) {
    return InkWell(
      onTap: () {
        if (Provider.of<AppProvider>(context, listen: false).accessToken !=
            null) {
          Navigator.pushNamed(context, AppRoute.seller_details,
              arguments: ScreenArguments(data: {
                "sellerId": presenter.response!.data![0].shopId.toString()
              }));
        } else {
          Navigator.pushNamed(context, AppRoute.login);
          Toast.createToast(
              context: context,
              message: "Login First...",
              duration: Duration(milliseconds: 1500));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sold By",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: AppFont.Poppins,
                color: AppColor.valueColor,
                fontSize: height * 1.8,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: height / 2),
          Text(
            sellerName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: height * 2,
              color: AppColor.primary,
              fontFamily: AppFont.Poppins,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget shareOption() {
    return Padding(
      padding: EdgeInsets.only(right: width * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Share",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: AppFont.Poppins,
                color: AppColor.valueColor,
                fontSize: height * 1.8,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(width: height / 2),
          InkWell(
            onTap: () {
              SocialShare.checkInstalledAppsForShare().then((value) {
                print(value);
                shareDialog(value);
              });
            },
            child: Icon(
              Icons.share,
              size: height * 3,
            ),
          ),
        ],
      ),
    );
  }

  void shareDialog(Map? value) {
    List<String> options = [];
    value?.forEach((K, V) {
      if (V) {
        options.add(K);
      }
    });
    showDialog(
      barrierColor: Colors.black.withOpacity(0.1),
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height * 2)),
          child: Container(
            width: width * 80,
            height: height * 15,
            padding: EdgeInsets.symmetric(
                horizontal: width * 10, vertical: height * 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(height * 2),
            ),
            child: GridView.builder(
              itemCount: options.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context, index) {
                return shareButton(options[index]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget shareButton(String option) {
    late IconData iconData;
    late Color color;

    String url = presenter.response!.data![0].productLink.toString();
    String name = presenter.response!.data![0].name.toString();
    switch (option) {
      case "sms":
        iconData = FontAwesomeIcons.sms;
        color = Colors.red;
        break;
      case "instagram":
        iconData = FontAwesomeIcons.instagramSquare;
        color = Colors.orangeAccent;
        break;
      case "facebook":
        color = Colors.blue;
        iconData = FontAwesomeIcons.facebookSquare;
        break;
      case "twitter":
        iconData = FontAwesomeIcons.twitterSquare;
        color = Colors.cyan;
        break;
      case "whatsapp":
        iconData = FontAwesomeIcons.whatsappSquare;
        color = Colors.lightGreen;
        break;
      case "telegram":
        iconData = FontAwesomeIcons.telegram;
        color = Color(0xFF2AABEE);
        break;
      default:
        iconData = FontAwesomeIcons.square;
        color = Color(0xFF2AABEE);
        break;
    }

    return IconButton(
        // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
        icon: FaIcon(
          iconData,
          size: height * 4,
          color: color,
        ),
        onPressed: () async {
          switch (option) {
            case "sms":
              SocialShare.shareSms(name, url: url);
              break;
            case "instagram":
              final file = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              SocialShare.shareInstagramStory(
                file!.path.toString(),
                backgroundTopColor: "#ffffff",
                backgroundBottomColor: "#000000",
                attributionURL: "https://deep-link-url",
              ).then((data) {
                print(data);
              });
              break;
            case "facebook":
              break;
            case "twitter":
              SocialShare.shareTwitter(name + "  " + url);
              break;
            case "whatsapp":
              SocialShare.shareWhatsapp(name + "  " + url);
              break;
            case "telegram":
              SocialShare.shareTelegram(name + "  " + url);
              break;
            default:
          }
        });
  }
}
