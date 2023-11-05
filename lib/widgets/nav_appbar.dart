import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/sellers/sellers_pie_chart_screen.dart';
import 'package:admin_web_portal/users/users_pie_chart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authentication/login_screen.dart';



class NavAppBar extends StatefulWidget with PreferredSizeWidget
{
  String? title;
  PreferredSizeWidget? preferredSizeWidget;

  NavAppBar({this.preferredSizeWidget, this.title,});

  @override
  State<NavAppBar> createState() => _NavAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}



class _NavAppBarState extends State<NavAppBar>
{
  @override
  Widget build(BuildContext context)
  {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors:
              [
                Colors.pinkAccent,
                Colors.deepPurpleAccent,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
      ),
      title: GestureDetector(
        onTap: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
        },
        child: Text(
          widget.title.toString(),
          style: const TextStyle(
            fontSize: 26,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        Row(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                },
                child: const Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const Text(
              "|",
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> SellersPieChartScreen()));
                },
                child: const Text(
                  "Sellers PieChart",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const Text(
              "|",
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> UsersPieChartScreen()));
                },
                child: const Text(
                  "Users PieChart",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const Text(
              "|",
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: ()
                {
                  FirebaseAuth.instance.signOut();

                  Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }
}