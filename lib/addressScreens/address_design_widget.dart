import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/address_changer.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/placeOrderScreen/place_order_screen.dart';


class AddressDesignWidget extends StatefulWidget
{
  Address? addressModel;
  int? index;
  int? value;
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  AddressDesignWidget({
    this.addressModel,
    this.index,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
  });

  @override
  State<AddressDesignWidget> createState() => _AddressDesignWidgetState();
}

class _AddressDesignWidgetState extends State<AddressDesignWidget>
{
  @override
  Widget build(BuildContext context)
  {
    return Card(
      color: Colors.white24,
      child: Column(
        children: [

          //address info
          Row(
            children: [

              Radio(
                groupValue: widget.index,
                value: widget.value!,
                activeColor: Colors.blue,
                onChanged: (val)
                {
                  //provider
                  Provider.of<AddressChanger>(context, listen: false).showSelectedAddress(val);
                },
              ),

              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Table(
                      children: [

                        TableRow(
                          children:
                          [
                            const Text(
                              "Name: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.addressModel!.name.toString(),
                            ),
                          ],
                        ),

                        const TableRow(
                          children:
                          [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),

                        TableRow(
                          children:
                          [
                            const Text(
                              "Phone Number: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.addressModel!.phoneNumber.toString(),
                            ),
                          ],
                        ),

                        const TableRow(
                          children:
                          [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),

                        TableRow(
                          children:
                          [
                            const Text(
                              "Full Address: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.addressModel!.completeAddress.toString(),
                            ),
                          ],
                        ),

                        const TableRow(
                          children:
                          [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),

          //button
          widget.value == Provider.of<AddressChanger>(context).count
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: const Text("Proceed"),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
              ),
              onPressed: ()
              {
                //send user to Place Order Screen finally
                Navigator.push(context, MaterialPageRoute(builder: (c)=> PlaceOrderScreen(
                  addressID: widget.addressID,
                  totalAmount: widget.totalAmount,
                  sellerUID: widget.sellerUID,
                )));
              },
            ),
          )
              : Container(),

        ],
      ),
    );
  }
}