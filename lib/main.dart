import 'package:flutter/material.dart';
import 'package:ppp/cart.dart';
import 'package:ppp/product.dart';
import './splash_screen.dart';
import 'package:provider/provider.dart';//we are using provider because it is needed in both productoverviscreen,productdetainscreen
import './products_overview_screen.dart';
import './product_detail_screen.dart';
import './prod.dart';
import 'cart_screen.dart';
import './orders.dart';
import 'orders_screen.dart';
import './user_productsScreen.dart';
import './edit_product_screen.dart';
import './auth_screen.dart';
import './auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(   //if we aree using nested provider then multipprovider help us to use all these provider like this.
      providers:[
         ChangeNotifierProvider.value(            //changenotifierwithproxyProvider is used when our provider is depend on some other provider and these other provider must declare before proxy provider and proxy provider must take it's name and name of that class which is linked to proxy itself 
           value: Auth(),
         ),    
          ChangeNotifierProxyProvider<Auth, Products>(
           
          update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items,
              ),
              create: (ctx)=>null,
        ),
     ChangeNotifierProvider( 
      create:(ctx)=>Cart(),
     ),
     ChangeNotifierProxyProvider<Auth,Orders>(
       update:(ctx,auth,previousOrders)=>Orders(auth.userId,
       previousOrders==null?[]:previousOrders.orders,
       ),
        create: (ctx)=>null,
     ),

      ],
   child:Consumer<Auth>(builder:(ctx,auth,_)=> 
   MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
  
      routes: {
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
    CartScreen.routeName:(ctx)=>CartScreen(),
 OrdersScreen.routeName:(ctx)=> OrdersScreen(),
     UserProductsScreen.routeName:(ctx)=>UserProductsScreen(),
     EditProductScreen.routeName:(ctx)=>EditProductScreen(),
      }
    ),
    ), 
    );   
  }
}