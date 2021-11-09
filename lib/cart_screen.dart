import 'package:flutter/material.dart';//show Cart if there then it would only import cart class from cart.dart
import 'package:ppp/cart_item.dart' as ci;
import 'package:provider/provider.dart';
import './cart.dart';
import './orders.dart';
class CartScreen extends StatelessWidget {
 static const routeName='/cart';
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title:Text('Your Cart'),
      ),
      body:Column(children:<Widget>[
        Card(margin:EdgeInsets.all(15),child:Padding(
          padding:EdgeInsets.all(8),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
                  Text('Total',style:TextStyle(fontSize: 20,),),
                  Spacer(),//it takes up all availabe space and push the widget to one another
                  Chip(
                    label:Text('\$${cart.totalAmount.toStringAsFixed(2)}',style:TextStyle(color:Theme.of(context).primaryTextTheme.headline6.color,)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  
                   
   // ignore: deprecated_member_use
   FlatButton(child:Text('ORDER NOW'),onPressed: cart.totalAmount<=0?null:(){
                Provider.of<Orders>(context,listen:false).addOrder(cart.items.values.toList(), cart.totalAmount,);
                     cart.clear();
                },textColor: Theme.of(context).primaryColor,),
                
              
            ],
          ),
        ),),
        SizedBox(height:10),
        Expanded(
          child:ListView.builder(
           itemCount: cart.items.length,
           itemBuilder: (ctx,i)=>ci.CartItem(cart.items.values.toList()[i].id,cart.items.keys.toList()[i],cart.items.values.toList()[i].price,cart.items.values.toList()[i].quantity,cart.items.values.toList()[i].title), 
          ),
        ),
      ],),
      
    );
  }

 
  
}