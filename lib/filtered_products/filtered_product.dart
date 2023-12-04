// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monarch_mart/app_components/app_string.dart';
import 'package:monarch_mart/app_models/filter_brand_response.dart';
import 'package:monarch_mart/app_models/filter_product_response.dart';
import 'package:monarch_mart/app_models/filter_seller_response.dart';
import 'package:monarch_mart/app_utils/FilterOptions/Dropdown.dart';
import 'package:monarch_mart/app_utils/FilterOptions/EndDrawer.dart';
import 'package:monarch_mart/app_utils/FilterOptions/FilterBar.dart';
import 'package:monarch_mart/app_utils/FilterOptions/SortingOption.dart';
import 'package:monarch_mart/app_utils/app_bottom_navigation.dart';
import 'package:monarch_mart/app_utils/app_shimer.dart';
import 'package:monarch_mart/app_utils/app_widgets.dart';
import 'package:monarch_mart/app_utils/appbar.dart';
import 'package:monarch_mart/app_utils/loading_progress.dart';
import 'package:monarch_mart/filtered_products/filter_provider.dart';
import 'package:provider/provider.dart';

class FilteredProduct extends StatefulWidget {
  String currentCategory;
  FilteredProduct({required this.currentCategory});

  @override
  _FilteredProductState createState() => _FilteredProductState();
}

class _FilteredProductState extends State<FilteredProduct> {
  late FilterProvider provider;
  late BuildContext context;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isInitialized = false;
  late double width, height, statusbar;
  ScrollController productScrollController = ScrollController();
  ScrollController brandScrollController = ScrollController();
  ScrollController shopScrollController = ScrollController();

  @override
  void initState() {
    initializer();
    super.initState();
  }

  @override
  void dispose() {
    productScrollController.dispose();
    brandScrollController.dispose();
    shopScrollController.dispose();
    super.dispose();
  }

  void initializer() {
    brandScrollController.addListener(() {
      if (brandScrollController.position.pixels ==
          brandScrollController.position.maxScrollExtent) {
        if (provider.fltrBrndPage <
            provider.filterbrandResponse!.meta!.lastPage) {
          LoadingProgrss.showProgress(context);
          provider.nextBrandsPage();
        } else {
          toast();
        }
      }
    });
    productScrollController.addListener(() {
      if (productScrollController.position.pixels ==
          productScrollController.position.maxScrollExtent) {
        if (provider.fltrPrdctPage <
            provider.filterproductResponse!.meta!.lastPage) {
          LoadingProgrss.showProgress(context);
          provider.nextProductPage();
        } else {
          toast();
        }
      }
    });

    shopScrollController.addListener(() {
      if (shopScrollController.position.pixels ==
          shopScrollController.position.maxScrollExtent) {
        if (provider.fltrShpsPage <
            provider.filtersellerResponse!.meta!.lastPage) {
          LoadingProgrss.showProgress(context);
          provider.nextSellerPage();
        } else {
          toast();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.currentCategory);
    statusbar = MediaQuery.of(context).padding.top;
    width = MediaQuery.of(context).size.width / 100;
    height = (MediaQuery.of(context).size.height - statusbar) / 100;
    this.context = context;
    if (!isInitialized) {
      provider = Provider.of<FilterProvider>(context, listen: false);
      provider.init(
          currentCategory: widget.currentCategory == AppString.New_Products
              ? AppString.Product
              : widget.currentCategory,
          sorting: widget.currentCategory == AppString.New_Products
              ? "new_arrival"
              : "");
      isInitialized = true;
    }

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: widget.currentCategory == AppString.New_Products
            ? Myappbar(context).appBarCommon(title: widget.currentCategory)
            : Myappbar(context).appBarFliter(provider),
        endDrawer: EndDrawer(
          width: width,
          height: height,
          presenter: provider,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<FilterProvider>(
              builder: (context, ob, child) => FilterBar(
                  category: (Offset offset) {
                    getfirstDropdown(offset);
                  },
                  sort: (Offset offset) {
                    getSortingWindow(offset);
                  },
                  filter: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                  dropdownOption: ob.currentCategory.isEmpty
                      ? widget.currentCategory
                      : ob.currentCategory,
                  isEnabled: provider.isEnabled),
            ),
            Consumer<FilterProvider>(builder: (context, ob, child) {
              switch (ob.categoryIndex) {
                case 0:
                  return brandGrid();
                case 1:
                  return productGrid();
                default:
                  return sellerGrid();
              }
            }),
          ],
        ),
        bottomNavigationBar: AppBottomNavigation(),
      ),
    );
  }

  void getfirstDropdown(Offset offset) {
    Dropdown.create(
        width: width,
        height: height,
        context: context,
        onClick: (String currentCategory) {
          provider.setCurrentCategory(currentCategory);
        },
        dx: offset.dx,
        dy: offset.dy);
  }

  void getSortingWindow(Offset offset) {
    SortingOption.create(
        width: width,
        height: height,
        currentSortingCategory: provider.sortingCategory,
        context: context,
        sortingFunction: (String sortingOption) {
          provider.setSortingCategory(sortingOption);
        },
        offset: offset);
  }

  Widget gridItemsProduct(FilterProductResponse? response) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          provider.onRefresh(1);
        },
        child: GridView.builder(
          itemCount: response!.data!.length,
          controller: productScrollController,
          padding: EdgeInsets.only(
              left: width * 6,
              right: width * 4,
              top: height * 2,
              bottom: height * 2),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: ((188.w) / (268.h))),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ProductItem(
              addToCart: () {},
              hasDiscount: response.data![index].hasDiscount,
              currentPrice: response.data![index].currentPrice,
              discount: response.data![index].discount.toString() + " %",
              productId: response.data![index].id.toString(),
              productTitle: response.data![index].name.toString(),
              imageUrl: response.data![index].thumbnailImage.toString(),
              basePrice: response.data![index].basePrice.toString(),
            );
          },
        ),
      ),
    );
  }

  Widget gridItemsBrands(FilterBrandResponse? response) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          provider.onRefresh(0);
        },
        child: GridView.builder(
          controller: brandScrollController,
          itemCount: response!.data!.length,
          padding: EdgeInsets.symmetric(
              horizontal: width * 2.5, vertical: height * 2),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: width * 2,
              mainAxisSpacing: width * 2,
              childAspectRatio: 1),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return BrandGridItem(
              width: width,
              height: height,
              brandProductUrl:
                  "/products/brand/" + response.data![index].id.toString(),
              name: response.data![index].name.toString(),
              imageUrl: response.data![index].logo.toString(),
            );
          },
        ),
      ),
    );
  }

  Widget gridItemsSellers(FilterSellerResponse? response) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          provider.onRefresh(2);
        },
        child: GridView.builder(
          controller: shopScrollController,
          itemCount: response!.data!.length,
          padding:
              EdgeInsets.symmetric(horizontal: width * 2.5, vertical: height),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: width * 2,
              mainAxisSpacing: width * 2,
              childAspectRatio: 1),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return SellerGridItem(
              sellerId: response.data![index].id.toString(),
              name: response.data![index].name.toString(),
              imageUrl: response.data![index].logo.toString(),
            );
          },
        ),
      ),
    );
  }

  Widget shimmer(double ratio) {
    return Expanded(
      child: GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: width * 2,
            mainAxisSpacing: width * 2,
            childAspectRatio: ratio),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return AppShimer(height: height, width: width);
        },
      ),
    );
  }

  Widget brandGrid() {
    Widget widget;
    if (provider.filterbrandResponse == null) {
      widget = shimmer(1);
    } else {
      widget = gridItemsBrands(provider.filterbrandResponse);
    }

    return widget;
  }

  Widget productGrid() {
    Widget widget;

    if (provider.filterproductResponse == null) {
      widget = shimmer(0.673);
    } else {
      widget = gridItemsProduct(provider.filterproductResponse);
    }

    return widget;
  }

  Widget sellerGrid() {
    Widget widget;
    if (provider.filtersellerResponse == null) {
      widget = shimmer(1);
    } else {
      widget = gridItemsSellers(provider.filtersellerResponse);
    }

    return widget;
  }

  void toast() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Container(
        height: height * 4.5,
        child: Center(
          child: Text(
            "No More Data to load",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ));
  }
}
