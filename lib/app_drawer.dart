import 'package:flutter/material.dart';
import 'package:ppp/user_productsScreen.dart';
import 'package:provider/provider.dart';
import 'orders_screen.dart';
import './auth.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
     width: 250,
      child:Column(children:<Widget>[
        AppBar(title:Text('Hello Brothers!!'),
        automaticallyImplyLeading: false,//it did not show  backbutton
        ),
        Divider(),
        ListTile(
          leading:Icon(Icons.shop),
          title:Text('Shop'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
 Divider(),
        ListTile(
          leading:Icon(Icons.payment),
          title:Text('Orders'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),

  Divider(),
        ListTile(
          leading:Icon(Icons.edit),
          title:Text('Manage Products'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
         Divider(),
        ListTile(
          leading:Icon(Icons.exit_to_app),
          title:Text('Logout'),
          onTap: (){
           Navigator.of(context).pop();//so that error may cclose first and error would not come
           Navigator.of(context).pushReplacementNamed('/');
           Provider.of<Auth>(context,listen:false).logout();
          },
        ),

      ],),
    );
  }
}