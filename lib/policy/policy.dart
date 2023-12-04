import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:monarch_mart/policy/policy_provider.dart';
import 'package:provider/provider.dart';

import '../app_utils/appbar.dart';

class Policy extends StatelessWidget {
  String headingTitle, policyType;

  Policy({required this.headingTitle, required this.policyType});

  late PolicyProvider policyProvider;

  @override
  Widget build(BuildContext context) {
    policyProvider = Provider.of<PolicyProvider>(context, listen: false);
    if (!policyProvider.isInitialize) {
      policyProvider.init(policyType: policyType);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Myappbar(context).appBarCommon(title: headingTitle),
      body: Consumer<PolicyProvider>(
        builder: (context, provider, child) {
          if (provider.response != null) {
            if (provider.details == null ||
                (provider.details?.isEmpty ?? false)) {
              return Center(
                child: Text("No Data available right now!!"),
              );
            } else {
              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Html(data: provider.details));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
