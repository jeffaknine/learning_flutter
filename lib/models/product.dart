import 'package:flutter/material.dart';

class Product {
  final String title;
  final String description;
  final String image;
  final double price;
  final bool isFavorite;
  final String userEmail;
  final String userId;

  Product(
      {@required this.description,
      @required this.image,
      @required this.price,
      @required this.title,
      this.isFavorite = false,
      @required this.userEmail,
      @required this.userId});
}
