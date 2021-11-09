import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ppp/app_drawer.dart';
import 'package:ppp/cart_screen.dart';
import 'package:ppp/prod.dart';
import './product_grid.dart';
import './badge.dart';
import 'package:provider/provider.dart';
import './cart.dart';


enum FilterOptions{
Favorites,
All,

}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites=false;
  var _isinit=true;
  var _isloading=false;
@override
void initState(){
  super.initState();
}

@override
void didChangeDependencies(){
if(_isinit){
setState(() {
  _isloading=true;
});
    Provider.of<Products>(context).fetchAndSetProducts().then((_){
     setState(() {
  _isloading=false;
});
    });
  }
  _isinit=false;
  super.didChangeDependencies();
}

  @override
  Widget build(BuildContext context) {
  // final productsContainer=Provider.of<Products>(context,listen:false);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions:<Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue){
              setState(() {
                 if(selectedValue==FilterOptions.Favorites){
               // productsContainer.showFavoriteOnly();
              _showOnlyFavorites=true;
              }
              else{
              //productsContainer.showAll();
              _showOnlyFavorites=false;
              }
                
              });
             
            },
            icon:Icon(Icons.more_vert,),itemBuilder:(_)=>
          [
            PopupMenuItem(child:Text('Only Favorite'),value:FilterOptions.Favorites),
            PopupMenuItem(child:Text('Show All'),value:FilterOptions.All),
          ],
          ),
          Consumer<Cart>(builder:(_,cart,ch)=>Badge(
            child:ch,
            value: cart.itemCount.toString(),),
          child:
            IconButton(
              icon:Icon(Icons.shopping_cart),
            onPressed: (){
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            ),
          
            ),
        
          
       
      
        ],
      
      ),
      drawer: AppDrawer(),
      body: _isloading?Center(child:CircularProgressIndicator(),): ProductsGrid(_showOnlyFavorites),
    );

  }
}
