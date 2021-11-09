import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  void _setValue(bool newvalue){
  isFavorite=newvalue;
  notifyListeners();
  }
Future  <void> toggleFavoriteStatus(String userId)async{
 final oldStatus=isFavorite;
    isFavorite=!isFavorite;
    print('ayush $userId');
     notifyListeners();
     final url=Uri.https('task1-c0839-default-rtdb.firebaseio.com','/Favorite/$userId/$id.json');
  try{
  final response= await http.put(url,body:json.encode({
    'isFavorite': isFavorite,
     
     }));
   
   if(response.statusCode>=400){
     _setValue(oldStatus);
     print('betaaa2??');
    
   }
  }
  catch(error){
      print('betaaa1??');
      print(error);
     _setValue(oldStatus);
 
  }
   
  }
}
