// import 'package:flutter/material.dart';
// import 'package:monarch_mart/app_components/app_color.dart';

// class NetworkProgress {
//   late BuildContext context;
//   void showProgress(BuildContext context) => showDialog(
//         context: context,
//         builder: (context) {
//           double width = MediaQuery.of(context).size.width / 100;
//           this.context = context;
//           return Dialog(
//             backgroundColor: Colors.transparent,
//             elevation: 0.0,
//             child: Container(
//               width: width * 35,
//               height: width * 35,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: <Widget>[
//                   Container(
//                     width: width * 25,
//                     height: width * 25,
//                     child: CircularProgressIndicator(
//                       backgroundColor: AppColor.primary,
//                       strokeWidth: width * 3,
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     width: width * 15,
//                     height: width * 15,
//                     decoration: BoxDecoration(
//                         color: Colors.white, shape: BoxShape.circle),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//   void closeDialog() {
//     Navigator.pop(context);
//   }
// }
