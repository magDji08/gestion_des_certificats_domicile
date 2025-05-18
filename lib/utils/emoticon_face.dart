import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class EmoticonFace extends StatelessWidget {
  late String emoticonFace;
  
  final dynamic onTap;
   EmoticonFace({super.key, required this.emoticonFace, required this.onTap});

  void setEmoti(String face){
    emoticonFace = face;
  }

  @override 
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
      color: Colors.blue[600],
      borderRadius: BorderRadius.circular(12)
    ),
    padding: EdgeInsets.all(20),
    
    child: InkWell(
      onTap: onTap,
      child: Text(emoticonFace,style: TextStyle(color: Colors.white, fontSize: 26),))
  );
  }
}