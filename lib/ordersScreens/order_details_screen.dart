import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/ordersScreens/address_design_widget.dart';
import 'package:users_app/ordersScreens/status_banner_widget.dart';

import '../global/global.dart';


class OrderDetailsScreen extends StatefulWidget
{
  String? orderID;

  OrderDetailsScreen({this.orderID,});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}



class _OrderDetailsScreenState extends State<OrderDetailsScreen>
{
  String orderStatus = "";

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, AsyncSnapshot dataSnapshot)
          {
            Map? orderDataMap;
            if(dataSnapshot.hasData)
            {
              orderDataMap = dataSnapshot.data.data() as Map<String, dynamic>;
              orderStatus = orderDataMap["status"].toString();

              return Column(
                children: [

                  StatusBanner(
                    status: orderDataMap["isSuccess"],
                    orderStatus: orderStatus,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "₹ " + orderDataMap["totalAmount"].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order ID = " + orderDataMap["orderId"].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Order at = " + DateFormat("dd MMMM, yyyy - hh:mm aa")
                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderDataMap["orderTime"]))),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),

                  orderStatus == "ended"
                     ? Image.asset("craftpics/delivered.png")
                      : Image.asset("craftpics/state.png"),

                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),

                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(sharedPreferences!.getString("uid"))
                        .collection("userAddress")
                        .doc(orderDataMap["addressID"])
                        .get(),
                    builder: (c, AsyncSnapshot snapshot)
                    {
                      if(snapshot.hasData)
                      {
                        return AddressDesign(
                          model: Address.fromJson(
                              snapshot.data.data() as Map<String, dynamic>
                          ),
                          orderStatus: orderStatus,
                          orderId: widget.orderID,
                          sellerId: orderDataMap!["sellerUID"],
                          orderByUser: orderDataMap["orderBy"],
                        );
                      }
                      else
                      {
                        return const Center(
                          child: Text(
                            "No data exists.",
                          ),
                        );
                      }
                    },
                  ),

                ],
              );
            }
            else
            {
              return const Center(
                child: Text(
                  "No data exists.",
                ),
              );
            }
          },
        ),
      ),
    );
  }
}