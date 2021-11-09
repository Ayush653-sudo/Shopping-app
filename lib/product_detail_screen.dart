import 'package:flutter/material.dart';
import './prod.dart';
import 'package:provider/provider.dart';
class ProductDetailScreen extends StatelessWidget {               //future
                                                                  //Ayush#18
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final productId = ModalRoute.of(context).settings.arguments as String; // is the id!
    // ...
 //final loadedProduct= Provider.of<Products>(context).items.firstWhere((pro) => pro.id==productId); it is one method 
 final loadedProduct=  Provider.of<Products>(context,listen:false).findById(productId); 
    return Scaffold(                   //if the listener is set to false then it mean that whenever notifylistener called to listening widgeet then widget which is set to false will not rebuilt
     // appBar: AppBar(
       // title: Text(loadedProduct.title),
     // ),
      body:CustomScrollView(
slivers:<Widget>[
  SliverAppBar(
    expandedHeight:300,
    pinned:true,
    flexibleSpace:FlexibleSpaceBar(title:Text(loadedProduct.title),
    background:Hero(
          tag:loadedProduct.id,
        child:Image.network(loadedProduct.imageUrl,fit:BoxFit.cover,),
      ) ,
    )
  ),
   SliverList(
     delegate:SliverChildListDelegate([
         SizedBox(height:10),
      Text('\$${loadedProduct.price}',style:TextStyle(color:Colors.grey,fontSize: 20,),textAlign: TextAlign.center,),
      SizedBox(height:10),
      Container(
        padding:EdgeInsets.symmetric(horizontal: 10),
        width:double.infinity,
        child:Text(loadedProduct.description,textAlign: TextAlign.center,softWrap: true,),
       
      ),
       SizedBox(height:800,),
     ]),
   ),
],
    
      ),
    );
  }
}
