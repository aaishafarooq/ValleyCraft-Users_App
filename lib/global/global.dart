import 'package:shared_preferences/shared_preferences.dart';

import '../assistantMethods/cart_methods.dart';

SharedPreferences? sharedPreferences;

final itemsImagesList =
[
  "craftpics/pic1.jpg",
  "craftpics/pic2.jpg",
  "craftpics/pic3.jpg",
  "craftpics/pic4.jpg",
  "craftpics/pic5.jpg",
  "craftpics/pic6.jpg",
  "craftpics/pic7.jpg",
  "craftpics/pic8.jpg",
  "craftpics/pic9.jpg",
  "craftpics/pic10.jpg",
  "craftpics/pic11.jpg",
  "craftpics/pic12.jpg",
  "craftpics/pic13.jpg",
  "craftpics/pic14.jpg",
  "craftpics/pic15.jpg",
  "craftpics/pic16.jpg",
  "craftpics/pic17.jpg",
  "craftpics/pic18.jpg",
  "craftpics/pic19.jpg",
  "craftpics/pic20.jpg",
  "craftpics/pic21.jpg",
];

CartMethods cartMethods = CartMethods();
double countStarsRating = 0.0;
String titleStarsRating = "";

String fcmServerToken ="key=AAAABN3vqc8:APA91bGybXGHZEhR8lmrIhUmv36B920v7Q1Zy7pb_f6nX_nQPodK7VVERmv-hTikOjMmB8Il_Ld_HyPWTeXBhqfR4g68pYhL-iJu2woMQdAKFrCrR7-UEuMExBaOCiD3mTTsiiL2SrHn";