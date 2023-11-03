import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier
{
  double totalAmountOfCartItems = 0;

  double get tAmount => totalAmountOfCartItems;

  showTotalAmountOfCartItems(double totalAmount) async
  {
    totalAmountOfCartItems = totalAmount;

    await Future.delayed(const Duration(milliseconds: 100), ()
    {
      notifyListeners();
    });
  }
}