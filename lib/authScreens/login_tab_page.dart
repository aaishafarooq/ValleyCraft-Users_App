import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';

import '../global/global.dart';
import '../sellersScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_dialog.dart';

class LoginTabPage extends StatefulWidget {


  @override
  State<LoginTabPage> createState() => _LoginTabPageState();
}

class _LoginTabPageState extends State<LoginTabPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
validateForm() {
  if (emailTextEditingController.text.isNotEmpty
      && passwordTextEditingController.text.isNotEmpty) {
    // allow user to login
    loginNow();
  }
  else {
    Fluttertoast.showToast(msg: "Please provide email snd password.");
  }
}
loginNow() async
{
  showDialog(
      context: context,
      builder: (c)
      {
        return LoadingDialogWidget(
            message: "Checking Credentials",
          );
      }
  );
  User ? currentUser;

  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailTextEditingController.text.trim(),
    password: passwordTextEditingController.text.trim(),
  ).then((auth)
  {
    currentUser = auth.user;
  }).catchError((errorMessage)
  {
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Error Occurred: \n $errorMessage");
  });
   if(currentUser != null)
   {
    checkIfUserRecordExists(currentUser!);
   }
}
  checkIfUserRecordExists(User currentUser) async
  {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((record) async
    {
     if(record.exists) //record exists
       {
         //status is approved
       if(record.data()!["status"] == "approved")
         {
           await sharedPreferences !.setString("uid", record.data()!["uid"]);
           await sharedPreferences !.setString("email", record.data()!["email"]);
           await sharedPreferences !.setString("name", record.data()!["name"]);
           await sharedPreferences !.setString("photoUrl", record.data()!["photoUrl"]);

           List<String> userCartList = record.data()!["userCart"].cast<String>();
           await sharedPreferences!.setStringList("userCart" , userCartList);
           // send user to home screen
           Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
         }
       else   //status is not approved
       {
         FirebaseAuth.instance.signOut();
         Navigator.pop(context);
         Fluttertoast.showToast(msg: "You have BLOCKED by admin. \n contact Admin: admin@ishop.com");
       }
       }
     else   //record not exists
       {
         FirebaseAuth.instance.signOut();
         Navigator.pop(context);
         Fluttertoast.showToast(msg: "This user's record do not exists.");
       }
    });
  }
    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          children: [

            Form(
              key: formKey,
              child: Column(
                children: [


                  //email
                  CustomTextField(
                    textEditingController: emailTextEditingController,
                    iconData: Icons.email,
                    hintText:  "Email",
                    isObsecre: false,
                    enabled: true,
                  ),
                  //password
                  CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    hintText:  "Password",
                    isObsecre: true,
                    enabled: true,
                  ),
                  //confirm password


                  const SizedBox(height: 10)
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 12,
                ),
              ),
              onPressed:()
              {
                validateForm();
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),

            const SizedBox(height: 30,),
          ],
        ),
      );
    }
  }

