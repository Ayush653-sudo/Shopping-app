import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier{//change notifier is class build in provider package and kind of inherited widget
List<Product>_item= [

 //   Product(
   //   id: 'p1',
     // title: 'Red Shirt',
     // description: 'A red shirt - it is pretty red!',
     // price: 29.99,
     // imageUrl:
       //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
   // ),
   // Product(
     // id: 'p2',
     // title: 'Trousers',
      //description: 'A nice pair of trousers.',
     // price: 59.99,
     // imageUrl:
      //    'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
   // ),
    //Product(
    //  id: 'p3',
      //title: 'Yellow Scarf',
      //description: 'Warm and cozy - exactly what you need for the winter.',
      //price: 19.99,
     // imageUrl:
       //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //),
    //Product(
      //id: 'p4',
      //title: 'A Pan',
      //description: 'Prepare any meal you want.',
      //price: 49.99,
      //imageUrl:
        //  'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //),
  ];
  final String authToken;
  final String userId;
  Products(this.authToken,this.userId,this._item);
  var _showFavoriteOnly=false;
   List<Product> get items{
     // ignore: sdk_version_ui_as_code
     if(_showFavoriteOnly){
       return _item.where((prodItem)=>prodItem.isFavorite).toList();
     }
     return [..._item];//this method do not send data by reference instead it send by everything by value so that notify listener my work properly
   }                           //whenever any change happen it give acess to notifyListener(); which notify all Listener widget
List<Product>get favoriteItems{
  return _item.where((prodItem)=>prodItem.isFavorite).toList();
}

Product findById(String id){
  return _item.firstWhere((pro)=>pro.id==id);
}
//void showFavoriteOnly(){
  //_showFavoriteOnly=true;
  //notifyListeners();
//}
//void showAll(){
  //_showFavoriteOnly=false;
  //notifyListeners();
//}
Future<void>fov(String prodID, dynamic prodData,var filterByUser,var userId)async{
 var url=Uri.https('shop-f8ed5-default-rtdb.firebaseio.com','/Favorite/$userId/$prodID.json');
   var favoriteResonse=await http.get(url);
   var favoriteData=json.decode(favoriteResonse.body); 


  final List<Product>loadedProducts=[];
   if(prodData['creatorId']==userId&&filterByUser==3)
  { print('Ayush Singh Tomar');
loadedProducts.add(Product(
  id:prodID,
  title:prodData['title'],
  description: prodData['description'],
  price: prodData['price'],
imageUrl: prodData['imageUrl'],
isFavorite: favoriteData==null?false:favoriteData['isFavorite']?? false,
));
  }
else if(filterByUser==2){
 loadedProducts.add(Product(
  id:prodID,
  title:prodData['title'],
  description: prodData['description'],
  price: prodData['price'],
imageUrl: prodData['imageUrl'],
isFavorite: favoriteData==null?false:favoriteData['isFavorite'] ?? false,
));
}
_item=loadedProducts;
notifyListeners();
}
Future<void> fetchAndSetProducts([var filterByUser=2]) async{//basically it is an optional argument mean we can or canot send it 
 // print('kfkfkfkf$authToken');
var url=Uri.https('shop-f8ed5-default-rtdb.firebaseio.com','/products.json');  
try{
final response=await http.get(url);
final extractedData=json.decode(response.body) as Map<String,dynamic>;

if(extractedData==null){
  return;
}
  //  url=Uri.https('shop-f8ed5-default-rtdb.firebaseio.com','/Favorite/$userId.json');
  // final favoriteResonse=await http.get(url);
  // final favoriteData=json.decode(favoriteResonse.body); 
extractedData.forEach((prodID,prodData) {
 
  fov(prodID,prodData,filterByUser,userId);
 
}
);
}


catch(error){
  
  throw(error);
}

}

Future<void> addProduct(Product product) async{
final url=Uri.https('shop-f8ed5-default-rtdb.firebaseio.com','/products.json');  
//here we had two method of using these to return future as we are returning in editprod by using async and await if they are used then no need to type return expecitailly as async return future only
//return http.post(url,body:json.encode(  await telling dart that it should wait ,await it wrap all code that come after it to then block (then ,catch error(can't use) bolck no needed now )invisibly
 try{
 final response= await http.post(url,body:json.encode(        //for error handling we can use try catch in async and await
  {
  'title':product.title,
 'description': product.description,
  'price':product.price,
  'imageUrl': product.imageUrl,
  'creatorId':userId,
  }
),);//.then((response){

final newProduct=Product(  // this is then part
  title:product.title,
  description: product.description,
  price:product.price,
  imageUrl: product.imageUrl,
  id:json.decode(response.body)['name'],
);
_item.add(newProduct);
notifyListeners();


}
catch(error){
  print(error);
throw error;
}


//}
//).catchError((error){
//print(error);
//throw error;
//} // );    //on error if catch error is declare here then it show that if error either throw by then and http then it directly come here after crossing (then in case of http throw error)
}        ///if theerror ocuur in our caseit would go addproduct listener in edit_product_screen


Future<void> updateProduct(String id,Product newProduct) async{
 final prodIndex= _item.indexWhere((prod)=>prod.id==id);
 final url=Uri.https('shop-f8ed5-default-rtdb.firebaseio.com','/products/$id.json');
await http.patch(url,body:json.encode({
   'title':newProduct.title,
   'description':newProduct.description,
   'umageUrl':newProduct.imageUrl,
   'price':newProduct.price,
 })); 

 _item[prodIndex]=newProduct;
 notifyListeners();
}
Future<void> deleteProduct(String id)async{
  final url=Uri.https('shop-f8ed5-default-rtdb.firebaseio.com','/products/$id.json');
  //we are storing its value in different variable because in dart it ill share same location and it took time to delete from server meanwhile we will delete from system memory  
  final existingProductIndex=_item.indexWhere((prod)=>prod.id==id);
  var existingProduct=_item[existingProductIndex];
  
  _item.removeAt(existingProductIndex);
  notifyListeners();
  final response=await http.delete(url);
    if(response.statusCode>=400){
      
    _item.insert(existingProductIndex,existingProduct);//http request throw only those error which affect http(like network connection) while it would not throw error in case of delete,patch,and put
    notifyListeners();
      throw Exception('Could not delete product.');
    }
    existingProduct=null;
}
}