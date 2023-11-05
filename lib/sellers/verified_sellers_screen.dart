import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../homeScreen/home_screen.dart';


class VerifiedSellersScreen extends StatefulWidget
{

  @override
  State<VerifiedSellersScreen> createState() => _VerifiedSellersScreenState();
}



class _VerifiedSellersScreenState extends State<VerifiedSellersScreen>
{
  QuerySnapshot? allApprovedSellers;


  showDialogBox(sellerDocumentId)
  {
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text(
              "Block Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to block this account ?",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                child: const Text(
                    "No"
                ),
              ),
              ElevatedButton(
                onPressed: ()
                {
                  Map<String, dynamic> sellerDataMap =
                  {
                    "status": "not approved",
                  };

                  FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(sellerDocumentId)
                      .update(sellerDataMap)
                      .whenComplete(()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

                    showReusableSnackBar(context, "Blocked Successfully.");
                  });
                },
                child: const Text(
                    "Yes"
                ),
              )
            ],
          );
        }
    );
  }

  getAllVerifiedSellers() async
  {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers)
    {
      setState(() {
        allApprovedSellers = allVerifiedSellers;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getAllVerifiedSellers();
  }

  @override
  Widget build(BuildContext context)
  {
    Widget verifiedSellersDesign()
    {
      if(allApprovedSellers == null)
      {
        return const Center(
          child: Text(
            "No Record Found.",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      }
      else
      {
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: allApprovedSellers!.docs.length,
          itemBuilder: (context, index)
          {
            return Card(
              elevation: 10,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 180,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            allApprovedSellers!.docs[index].get("photoUrl"),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Text(
                    allApprovedSellers!.docs[index].get("name"),
                  ),

                  Text(
                    allApprovedSellers!.docs[index].get("email"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //block now
                      GestureDetector(
                        onTap: ()
                        {
                          showDialogBox(allApprovedSellers!.docs[index].id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/block.png",
                                width: 56,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Block Now",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //earnings
                      GestureDetector(
                        onTap: ()
                        {
                          showReusableSnackBar(
                            context,
                            "Total Earnings = ".toUpperCase()
                                + "€ " + allApprovedSellers!.docs[index].get("earnings").toString(),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/earnings.png",
                                width: 56,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "€ " + allApprovedSellers!.docs[index].get("earnings").toString(),
                                style: const TextStyle(
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: NavAppBar(title: "Verified Sellers Accounts",),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: verifiedSellersDesign(),
        ),
      ),
    );
  }
}