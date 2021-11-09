import 'package:flutter/material.dart';

import './product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'cart.dart';
import 'product.dart';
import 'auth.dart';

class ProductItem extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
final product=Provider.of<Product>(context,listen: false);
final authData=Provider.of<Auth>(context,listen:false);
  //if we are using above method of product declaration then if that ase whole widget tree will rerun and if we want only some particular to rerun then we should wrap it in container(consumer)
  final cart=Provider.of<Cart>(context,listen:false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Hero(
              tag:product.id,
              child: FadeInImage(placeholder:AssetImage('assets/images/product-placeholder.png'),
              image:NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
               ),
            ), 
           
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
           leading: Consumer<Product>( 
              builder:(ctx,product,child)=>
              IconButton(
              icon: Icon(product.isFavorite?Icons.favorite:Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
               product.toggleFavoriteStatus(authData.userId);
              },
            ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(product.id,product.price,product.title);
                // ignore: deprecated_member_use
                ScaffoldMessenger.of(context).hideCurrentSnackBar();//this would hide first items immediately if second is pressed
              // ignore: deprecated_member_use   
                ScaffoldMessenger.of(context).showSnackBar(  //these scaffold is directly linked to last scaffold towhich these page is linked 
              SnackBar(
          content:Text('Added item to cart',),
          duration:Duration(seconds: 2),
          action:SnackBarAction(label: 'UNDO', onPressed: (){
          cart.removeSingleItem(product.id);  
          },),

            ),
                
                );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        
        ),
      
    );
  }
}
