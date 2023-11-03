import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../global/global.dart';
import '../models/brands.dart';
import '../models/items.dart';
import '../widgets/text_delegate_header_widget.dart';
import 'items_ui_design_widget.dart';


class ItemsScreen extends StatefulWidget
{
  Brands? model;

  ItemsScreen({this.model,});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}



class _ItemsScreenState extends State<ItemsScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors:
                [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: const Text(
          "ValleyCraft",
          style: TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [

          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(title: widget.model!.brandTitle.toString() + "'s Items"),
          ),

          //1. query
          //2. model
          //3. ui design widget

          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.sellerUID.toString())
                .collection("brands")
                .doc(widget.model!.brandID)
                .collection("items")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot dataSnapshot)
            {
              if(dataSnapshot.hasData) //if brands exists
                  {
                //display brands
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c)=> const StaggeredTile.fit(1),
                  itemBuilder: (context, index)
                  {
                    Items itemsModel = Items.fromJson(
                      dataSnapshot.data.docs[index].data() as Map<String, dynamic>,
                    );

                    return ItemsUiDesignWidget(
                      model: itemsModel,

                    );
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
              }
              else //if brands NOT exists
                  {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No items exists",
                    ),
                  ),
                );
              }
            },
          ),

        ],
      ),
    );
  }
}