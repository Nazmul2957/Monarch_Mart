import 'category_response.dart';

class DrawerItemModel {
  bool isExpanded;
  Data data;
  CategoryResponse? subCategoryResponse;

  DrawerItemModel(
      {required this.isExpanded,
      required this.data,
      required this.subCategoryResponse});
}
