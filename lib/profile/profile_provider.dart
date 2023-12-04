import 'package:flutter/cupertino.dart';
import 'package:monarch_mart/state_manager/app_provider.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier {
  String? imageurl;
  String? userName;
  String? email;
  late AppProvider appProvider;
  init(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context, listen: true);
    imageurl = appProvider.userAvter;
    userName = appProvider.userName;
    email = appProvider.userEmail;
    print("called");
  }
}
