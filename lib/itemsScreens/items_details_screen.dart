import 'package:cart_stepper/cart_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/assistantMethods/cart_methods.dart';
import 'package:users_app/widgets/appbar_cart_badge.dart';
import '../global/global.dart';
import '../models/items.dart';




class ItemsDetailsScreen extends StatefulWidget
{
  Items? model;

  ItemsDetailsScreen({this.model,});

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}



class _ItemsDetailsScreenState extends State<ItemsDetailsScreen>
{
  int counterLimit = 1;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithCartBadge(
        sellerUID: widget.model!.sellerUID.toString(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()
        {
          int itemCounter = counterLimit;

          List<String> itemsIDsList = cartMethods.separateItemIDsFromUserCartList();

          //1. check if item exist already in cart
          if(itemsIDsList.contains(widget.model!.itemID))
          {
            Fluttertoast.showToast(msg: "Item is already in Cart.");
          }
          else
          {
            //2. add item in cart
            cartMethods.addItemToCart(
              widget.model!.itemID.toString(),
              itemCounter,
              context,
            );
          }
        },
        label: const Text(
            "Add to Cart"
        ),
        icon: const Icon(
          Icons.add_shopping_cart_rounded,
          color: Colors.white,
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.network(
              widget.model!.thumbnailUrl.toString(),
            ),

            //implement the item counter
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CartStepperInt(
                  count: counterLimit,
                  size: 45,

                  //deActiveBackgroundColor: Colors.red,
                  //activeForegroundColor: Colors.white,
                //  activeBackgroundColor: Colors.pinkAccent,
                  didChangeCount: (value)
                  {
                    if(value < 1)
                    {
                      Fluttertoast.showToast(msg: "The quantity cannot be less than 1");
                      return;
                    }

                    setState(() {
                      counterLimit = value;
                    });
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                widget.model!.itemTitle.toString() + " :",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.greenAccent,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.model!.price.toString() + " ₹",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.greenAccent,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 290.0),
              child: Divider(
                height: 1,
                thickness: 2,
                color: Colors.greenAccent,
              ),
            ),

            const SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }
}