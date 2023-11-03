import 'package:flutter/material.dart';

import '../models/items.dart';
import 'items_details_screen.dart';




class ItemsUiDesignWidget extends StatefulWidget
{
  Items? model;

  ItemsUiDesignWidget({this.model,});

  @override
  State<ItemsUiDesignWidget> createState() => _ItemsUiDesignWidgetState();
}




class _ItemsUiDesignWidgetState extends State<ItemsUiDesignWidget>
{
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsDetailsScreen(
          model: widget.model,
        )));
      },
      child: Card(
        color: Colors.black,
        elevation: 10,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    widget.model!.thumbnailUrl.toString(),
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 1,),

                Text(
                  widget.model!.itemTitle.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 1,),

                Text(
                  widget.model!.itemInfo.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}