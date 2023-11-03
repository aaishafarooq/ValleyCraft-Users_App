import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/models/sellers.dart';
import 'package:users_app/sellersScreens/sellers_ui_design_widget.dart';


class SearchScreen extends StatefulWidget
{

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}




class _SearchScreenState extends State<SearchScreen>
{
  String sellerNameText = "";
  Future<QuerySnapshot>? storesDocumentsList;

  initializeSearchingStores(String textEnteredbyUser)
  {
    storesDocumentsList = FirebaseFirestore.instance
        .collection("sellers")
        .where("name", isGreaterThanOrEqualTo: textEnteredbyUser)
        .get();
  }

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
        automaticallyImplyLeading: true,
        title: TextField(
          onChanged: (textEntered)
          {
            setState(() {
              sellerNameText = textEntered;
            });

            initializeSearchingStores(sellerNameText);
          },
          decoration: InputDecoration(
            hintText: "Search Seller here...",
            hintStyle: const TextStyle(color: Colors.white54),
            suffixIcon: IconButton(
              onPressed: ()
              {
                initializeSearchingStores(sellerNameText);
              },
              icon: const Icon(Icons.search),
              color: Colors.white,
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: storesDocumentsList,
        builder: (context, AsyncSnapshot snapshot)
        {
          if(snapshot.hasData)
          {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index)
              {
                Sellers model = Sellers.fromJson(
                    snapshot.data.docs[index].data() as Map<String, dynamic>
                );

                return SellersUIDesignWidget(
                  model: model,
                );
              },
            );
          }
          else
          {
            return const Center(
              child: Text(
                  "No record found."
              ),
            );
          }
        },
      ),
    );
  }
}