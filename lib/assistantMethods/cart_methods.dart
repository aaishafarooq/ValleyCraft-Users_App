import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/cart_item_counter.dart';
import 'package:users_app/global/global.dart';

class CartMethods
{
  addItemToCart(String? itemId, int itemCounter, BuildContext context)
  {
    List<String>? tempList = sharedPreferences!.getStringList("userCart");
    tempList!.add(itemId.toString() + ":" + itemCounter.toString()); //2367121:5

    //save to firestore database
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update(
        {
          "userCart": tempList,
        }).then((value)
    {
      Fluttertoast.showToast(msg: "Item added successfully.");

      //save to local storage
      sharedPreferences!.setStringList("userCart", tempList);

      //update item badge number
      Provider.of<CartItemCounter>(context, listen: false).showCartListItemsNumber();
    });
  }

  clearCart(BuildContext context)
  {
    //clear in local storage
    sharedPreferences!.setStringList("userCart", ["initialValue"]);

    List<String>? emptyCartList = sharedPreferences!.getStringList("userCart");

    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .update(
        {
          "userCart": emptyCartList,
        }).then((value)
    {
      //update item badge number
      Provider.of<CartItemCounter>(context, listen: false).showCartListItemsNumber();
    });
  }


  //2367121:5 ==> 2367121
  separateItemIDsFromUserCartList()
  {
    //2367121:5
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");

    List<String> itemsIDsList = [];
    for(int i=1; i<userCartList!.length; i++)
    {
      //2367121:5
      String item = userCartList[i].toString();
      var lastCharacterPositionOfItemBeforeColon = item.lastIndexOf(":");

      //2367121
      String getItemID = item.substring(0, lastCharacterPositionOfItemBeforeColon);
      itemsIDsList.add(getItemID);
    }

    return itemsIDsList;
  }

  //2367121:5 ==> 5
  separateItemQuantitiesFromUserCartList()
  {
    //2367121:5
    List<String>? userCartList = sharedPreferences!.getStringList("userCart");
    print("userCartList = ");
    print(userCartList);

    List<int> itemsQuantitiesList = [];
    for(int i=1; i<userCartList!.length; i++)
    {
      //2367121:5
      String item = userCartList[i].toString();

      // 0=[:] 1=[5]
      var colonAndAfterCharactersList = item.split(":").toList(); // 0=[:] 1=[5]

      //5
      var quantityNumber = int.parse(colonAndAfterCharactersList[1].toString());

      itemsQuantitiesList.add(quantityNumber);
    }

    print("itemsQuantitiesList = ");
    print(itemsQuantitiesList);
    return itemsQuantitiesList;
  }


  separateOrderItemIDs(productIDs)
  {
    //2367121:5
    List<String>? userCartList = List<String>.from(productIDs);

    List<String> itemsIDsList = [];
    for(int i=1; i<userCartList.length; i++)
    {
      //2367121:5
      String item = userCartList[i].toString();
      var lastCharacterPositionOfItemBeforeColon = item.lastIndexOf(":");

      //2367121
      String getItemID = item.substring(0, lastCharacterPositionOfItemBeforeColon);
      itemsIDsList.add(getItemID);
    }

    return itemsIDsList;
  }

  separateOrderItemsQuantities(productIDs)
  {
    //2367121:5
    List<String>? userCartList = List<String>.from(productIDs);
    print("userCartList = ");
    print(userCartList);

    List<String> itemsQuantitiesList = [];
    for(int i=1; i<userCartList.length; i++)
    {
      //2367121:5
      String item = userCartList[i].toString();

      // 0=[:] 1=[5]
      var colonAndAfterCharactersList = item.split(":").toList(); // 0=[:] 1=[5]

      //'5'
      var quantityNumber = int.parse(colonAndAfterCharactersList[1].toString());

      itemsQuantitiesList.add(quantityNumber.toString());
    }

    print("itemsQuantitiesList = ");
    print(itemsQuantitiesList);
    return itemsQuantitiesList;
  }
}