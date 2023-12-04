import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:monarch_mart/app_components/app_color.dart';
import 'package:monarch_mart/app_models/review_response.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_cachedimage.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/loading_progress.dart';
import 'package:monarch_mart/app_utils/toast.dart';
import 'package:provider/provider.dart';

import 'product_review_provider.dart';

// ignore: must_be_immutable
class ProductReviews extends StatelessWidget {
  late double width, height, statusbar;
  late BuildContext context;
  String productId;
  ProductReviews({required this.productId});
  ScrollController reviewScrollController = ScrollController();
  var controller = TextEditingController();
  late ProductReviewProvider presenter;

  Future onRefresh() async {
    presenter.refresh();
  }

  initiallizer() {
    reviewScrollController.addListener(() {
      if (reviewScrollController.position.pixels ==
          reviewScrollController.position.maxScrollExtent) {
        if (presenter.page < presenter.reviewResponse!.meta!.lastPage!) {
          LoadingProgrss.showProgress(context);
          presenter.nextPage();
        } else {
          toast();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;
    presenter = Provider.of<ProductReviewProvider>(context, listen: false);

    if (!presenter.isInitialize) {
      presenter.init(productId: productId, context: context);
    }
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: Myappbar(context).appBarCommon(title: "Reviews"),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Consumer<ProductReviewProvider>(builder: (context, ob, child) {
                    if (ob.reviewResponse != null) {
                      if (ob.reviewResponse!.data!.isNotEmpty) {
                        return RefreshIndicator(
                          color: AppColor.secondary,
                          backgroundColor: Colors.white,
                          onRefresh: onRefresh,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: width * 5),
                            scrollDirection: Axis.vertical,
                            controller: reviewScrollController,
                            itemCount: ob.reviewResponse!.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(vertical: height),
                                  child: reviewItem(ob.reviewResponse!.data![index]));
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                              "No review yet, Be the first to review this product"),
                        );
                      }
                    } else {
                      return shimer();
                    }
                  }),
                ],
              ),

            ),
            bottomOptions(),
          ],
        ),
        bottomNavigationBar: AppBottomNavigation(),
      ),
    );
  }

  Widget bottomOptions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 5),
      width: width * 100,
      height: height * 16,
      child: Column(
        children: [
          giveStar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textField(),
              sendButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget shimer() {
    return ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.symmetric(horizontal: width * 5),
      itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: height),
          child: AppShimer(
            width: width * 90,
            height: height * 10,
          )),
    );
  }

  Widget reviewItem(Data data) {
    return Container(
      width: width * 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              image(data.avatar.toString()),
              SizedBox(width: width * 2),
              nameCommentTime(data.userName!, data.time!),
              Spacer(),
              ratingBar(data.rating!),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: width * 2, vertical: height),
            child: expandableDescription(data.comment),
          ),
        ],
      ),
    );
  }

  ExpandableNotifier expandableDescription(String? comment) {
    return ExpandableNotifier(
        child: ScrollOnExpand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            collapsed: Text(comment.toString(),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: AppColor.secondary,
                )),
            expanded: Container(
                child: Text(comment.toString(),
                    style: TextStyle(
                      color: AppColor.secondary,
                    ))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Builder(
                builder: (context) {
                  var controller = ExpandableController.of(context);
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: AppColor.primary,
                    ),
                    child: Text(
                      !controller!.expanded ? "View More" : "Show Less",
                      style: TextStyle(color: AppColor.white, fontSize: 11),
                    ),
                    onPressed: () {
                      controller.toggle();
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    ));
  }

  Widget image(String url) {
    return Container(
      width: width * 15,
      height: width * 15,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(height)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height * 1.5),
        child: CachedImage(
          imageUrl: url,
        ),
      ),
    );
  }

  Widget nameCommentTime(String name, String commentTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          name,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              color: AppColor.secondary,
              fontSize: height * 1.6,
              fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            commentTime,
            style: TextStyle(color: AppColor.secondary),
          ),
        ),
      ],
    );
  }

  Widget ratingBar(double rating) {
    return Padding(
        padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: width * 2),
        child: Container(
          child: RatingBar(
            itemSize: 12.0,
            ignoreGestures: true,
            initialRating: rating,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            ratingWidget: RatingWidget(
              full: Icon(
                Icons.star,
                color: Colors.amber,
              ),
              empty: Icon(
                Icons.star_border_outlined,
                color: Color.fromRGBO(224, 224, 225, 1),
              ),
              half: Icon(
                Icons.star_half,
                color: Colors.amber,
              ),
            ),
            itemPadding: EdgeInsets.only(right: 1.0),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
        ));
  }

  Widget giveStar() {
    return Consumer<ProductReviewProvider>(
        builder: (context, ob, child) => Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: RatingBar.builder(
                itemSize: height * 2.5,
                initialRating: ob.myrating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                glowColor: Colors.amber,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
                onRatingUpdate: (rating) {
                  presenter.setRating(rating);
                },
              ),
            ));
  }

  Widget textField() {
    return Container(
        width: width * 78,
        child: TextField(
          autofocus: false,
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(251, 251, 251, 1),
            hintText: "Type your review here ...",
            hintStyle:
                TextStyle(fontSize: height * 1.6, color: AppColor.secondary),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColor.secondary, width: width / 5),
              borderRadius: BorderRadius.circular(height * 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColor.secondary, width: width / 6),
              borderRadius: BorderRadius.circular(height * 2),
            ),
            contentPadding: EdgeInsets.only(left: width * 2),
          ),
        ));
  }

  Widget sendButton() {
    return InkWell(
      onTap: () {
        if (controller.text.isNotEmpty) {
          presenter.submitReview(
              rating: presenter.myrating, comment: controller.text);
        } else {
          Toast.createToast(
              context: context,
              message: "Write somethong first!!!",
              duration: Duration(milliseconds: 1500));
        }
      },
      borderRadius: BorderRadius.circular(width * 5),
      child: Container(
        width: width * 10,
        height: width * 10,
        decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(width * 5)),
        child: Icon(
          Icons.send,
          color: Colors.white,
          size: height * 2.5,
        ),
      ),
    );
  }

  void toast() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Container(
        height: height * 4.5,
        child: Center(
          child: Text(
            "No More Reviews to load",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ));
  }
}
