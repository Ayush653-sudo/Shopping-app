import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './prod.dart';
import './product_item.dart';
class ProductsGrid extends StatelessWidget {
  final bool showfavs;
  ProductsGrid(this.showfavs);

  @override
  Widget build(BuildContext context) {
  
 final productsData= Provider.of<Products>(context);
 final products=showfavs?productsData.favoriteItems:productsData.items;
    return GridView.builder(
               
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        itemBuilder: (ctx, i) =>ChangeNotifierProvider.value( 
          //create:(c)=>products[i]
          value: products[i],//i am noot using create method because it is harmful in case of grid because grid will forget data which is not on screen yet (like list)and what happend that provider will forget every new change which has happend so by using value it is smart to keep eye on changes 
          child:ProductItem(  //whenever any new product bult changenotifier will remove earlier once
              
           ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      

    );
  }
}