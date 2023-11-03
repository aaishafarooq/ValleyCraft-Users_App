import 'package:flutter/material.dart';


class TextFieldAddressWidget extends StatelessWidget
{
  String? hint;
  TextEditingController? controller;

  TextFieldAddressWidget({this.hint, this.controller,});

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
        validator: (value)=> value!.isEmpty ? "Field can not be Empty." : null,
      ),
    );
  }
}