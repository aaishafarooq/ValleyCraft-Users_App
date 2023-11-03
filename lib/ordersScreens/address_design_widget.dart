import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/ratingScreen/rate_seller_screen.dart';

import '../global/global.dart';
import '../splashScreen/my_splash_screen.dart';
import 'package:http/http.dart' as http;


class AddressDesign extends StatelessWidget
{
  Address? model;
  String? orderStatus;
  String? orderId;
  String? sellerId;
  String? orderByUser;

  AddressDesign({
    this.model,
    this.orderStatus,
    this.orderId,
    this.sellerId,
    this.orderByUser,
  });

  sendNotificationToSeller(sellerUID, userOrderID) async
  {
    String sellerDeviceToken = "";

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .get()
        .then((snapshot)
    {
      if(snapshot.data()!["sellerDeviceToken"] != null)
      {
        sellerDeviceToken = snapshot.data()!["sellerDeviceToken"].toString();
      }
    });

    notificationFormat(
      sellerDeviceToken,
      userOrderID,
      sharedPreferences!.getString("name"),
    );
  }

  notificationFormat(sellerDeviceToken, getUserOrderID, userName)
  {
    Map<String, String> headerNotification =
    {
      'Content-Type': 'application/json',
      'Authorization': fcmServerToken,
    };

    Map bodyNotification =
    {
      'body': "Dear seller, Parcel (# $getUserOrderID) has Received Successfully by user $userName. \nPlease Check Now",
      'title': "Parcel Received by User",
    };

    Map dataMap =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userOrderId": getUserOrderID,
    };

    Map officialNotificationFormat =
    {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': sellerDeviceToken,
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [

        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Shipping Details:',
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold
            ),
          ),
        ),

        const SizedBox(
          height: 6.0,
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [

              //name
              TableRow(
                children:
                [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    model!.name.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const TableRow(
                children:
                [
                  SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),

              //phone
              TableRow(
                children:
                [
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    model!.phoneNumber.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.completeAddress.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),

        GestureDetector(
          onTap: ()
          {
            if(orderStatus == "normal")
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MySplashScreen()));
            }
            else if(orderStatus == "shifted")
            {
              //implement Parcel Received feature
              FirebaseFirestore.instance
                  .collection("orders")
                  .doc(orderId)
                  .update(
                  {
                    "status": "ended",
                  }).whenComplete(()
              {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(orderByUser)
                    .collection("orders")
                    .doc(orderId)
                    .update(
                    {
                      "status": "ended",
                    });

                //send notification to seller
                sendNotificationToSeller(sellerId, orderId);

                Fluttertoast.showToast(msg: "Confirmed Successfully.");
                Navigator.push(context, MaterialPageRoute(builder: (context) => MySplashScreen()));
              });
            }
            else if(orderStatus == "ended")
            {
              //implement Rate this Seller feature
              Navigator.push(context, MaterialPageRoute(builder: (context) => RateSellerScreen(
                sellerId: sellerId,
              )));
            }
            else
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MySplashScreen()));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey,
                      Colors.blueAccent,
                    ],
                    begin:  FractionalOffset(0.0, 0.0),
                    end:  FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  )
              ),
              width: MediaQuery.of(context).size.width - 40,
              height: orderStatus == "ended" ? 60 : MediaQuery.of(context).size.height * .10,
              child: Center(
                child: Text(
                  orderStatus == "ended"
                      ? "Do you want to Rate this Seller?"
                      : orderStatus == "shifted"
                      ? "Parcel Received, \nClick to Confirm"
                      : orderStatus == "normal"
                      ? "Go Back"
                      : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}