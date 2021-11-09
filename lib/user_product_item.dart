import 'package:flutter/material.dart';
import './edit_product_screen.dart';
import 'package:provider/provider.dart';
import './prod.dart';
import 'product.dart';
class UserProductItem extends StatelessWidget {
final String id;
final String title;
final String imageUrl;

UserProductItem(this.id,this.title,this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold= Scaffold.of(context);
    return ListTile(
      title:Text(title),
      leading:CircleAvatar(backgroundImage:NetworkImage(imageUrl),),
trailing: Container(
  width:100,
  child:   Row(children:<Widget>[
  
    IconButton(icon:Icon(Icons.edit),onPressed: (){
      Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
    },),
  
    IconButton(icon:Icon(Icons.delete),onPressed: () async {
      try{
 await Provider.of<Products>(context,listen:false).deleteProduct(id);
      }
      catch(error){
       // ignore: deprecated_member_use
       scaffold.showSnackBar(SnackBar(content:Text('Deleting failed!'),//we should not use scaffold here because context will confuse in these case
        ),
        );
      }
     
    }
    ,color:Theme.of(context).primaryColor),
    
    
  
  ],),
),      
    );
  }
}