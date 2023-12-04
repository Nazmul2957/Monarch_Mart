import 'package:flutter/material.dart';
import 'package:monarch_mart/app_utils/app_screen.dart';
import 'package:monarch_mart/app_utils/app_statusbar.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/app_utils/appbar.dart';

class Offer extends StatefulWidget {
  @override
  _OfferState createState() => _OfferState();
}

class _OfferState extends State<Offer> {
  late AppScreen screen;

  @override
  Widget build(BuildContext context) {
    Statusbar.darkIcon();
    screen = AppScreen(context);

    return Scaffold(
        appBar: Myappbar(context)
            .appbar(isFromHome: false, title: "Offers", ontap: () {}),
        body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: screen.width * 5, vertical: screen.height),
          children: [
            Header(title: "Upto 25% Off on Women Shoes"),
            SizedBox(height: screen.height * 2),
            GridView.builder(
                shrinkWrap: true,
                itemCount: 10,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: screen.width * 2,
                    mainAxisSpacing: screen.height * 1.5,
                    childAspectRatio:
                        ((screen.width * 40) / (screen.height * 35))),
                itemBuilder: (context, index) => ProductItem(
                      productId: "12",
                      productTitle: "This is title",
                      basePrice: "\$ 300",
                      addToCart: () {},
                      imageUrl: "",
                      hasDiscount: true,
                    ))
          ],
        ));
  }
}
