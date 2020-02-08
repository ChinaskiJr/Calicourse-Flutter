import 'package:calicourse_front/models/Shop.dart';
import 'package:calicourse_front/parameters/parameters.dart';
import 'package:flutter/material.dart';

class ShopContainer extends Container {
  ShopContainer(BuildContext context, Shop shop): super(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: secondaryColor,
      ),
      child: Center(
        child: Text(
          shop.name,
          style: TextStyle(
              fontSize: globalFontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    width: MediaQuery.of(context).size.width * 0.25,
    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02)
  );
}