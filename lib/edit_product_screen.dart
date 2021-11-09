import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ppp/product.dart';
import './prod.dart';
import 'package:provider/provider.dart';
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode=FocusNode();
  final _form=GlobalKey<FormState>();
  var _editedProduct=Product(id:null,title:'',price:0,description:'',imageUrl:'',);
 var _initValues={
   'title':'',
   'description':'',
   'price':'',
   'imageUrl':'',
 };
 var _isInit=true;
 var _isLoading=false;
   @override
  void initState(){
   _imageUrlFocusNode.addListener(_updateImageUrl);
   super.initState(); 
  }
 
 @override
 void didChangeDependencies(){
   if(_isInit){
final productId=ModalRoute.of(context).settings.arguments as String;
  if(productId!=null){
  _editedProduct= Provider.of<Products>(context,listen:false).findById(productId);
  _initValues={
    'title':_editedProduct.title,
     'description':_editedProduct.description,
   'price': _editedProduct.price.toString(),
   'imageUrl':'',
  };
  _imageUrlController.text=_editedProduct.imageUrl;
  }
   }
   _isInit=false;
   super.didChangeDependencies();
 }
 
 
 
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }
 void _updateImageUrl(){
if(!_imageUrlFocusNode.hasFocus){


                    if((!_imageUrlController.text.startsWith('http')&&!_imageUrlController.text.startsWith('https'))||(!_imageUrlController.text.endsWith('.png')&&!_imageUrlController.text.endsWith('.jpg')&&!_imageUrlController.text.endsWith('jpeg'))){
                      return ;
                     }

  setState(() {
    
  });
}
 }
 Future<void> _saveForm() async {
   final isValid=_form.currentState.validate();//we can use this to check validation instead of autovalidate
   if(!isValid)
  { return;
  }
   _form.currentState.save();
  setState((){
_isLoading=true;
  });
   

if(_editedProduct.id!=null){
 await Provider.of<Products>(context,listen:false).updateProduct(_editedProduct.id,_editedProduct);
   setState((){
_isLoading=false;
  });
 Navigator.of(context).pop();
}
else{
  await Provider.of<Products>(context,listen:false).addProduct(_editedProduct)
   
   .catchError((error){
return showDialog<Null>(context: context, builder: (ctx)=>AlertDialog(title: Text('An error occurred'),content: Text('Something went wrong'),
actions:<Widget>[             //showdialog always return future it will then pas to then()
  // ignore: deprecated_member_use
  FlatButton(child:Text('Okay'),onPressed: (){
    Navigator.of(ctx).pop();
  },),
],

),
);

   })
   
   .then((_){
       setState((){
_isLoading=false;
  });
     Navigator.of(context).pop();
   });
 }

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions:<Widget>[
          IconButton(icon:Icon(Icons.save),onPressed:_saveForm,),
        ],
      ),
      body: _isLoading?Center(child:CircularProgressIndicator(),):
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue:_initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  if(value.isEmpty){
                  return 'please provide a value';
                  }
                  return null;
                },
                  onSaved:(value){       //these function is run by _foamsave which need key and it automatically save foAM
                    _editedProduct=Product(title:value,
                    price:_editedProduct.price,
                    description:_editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    );
                  },
                
              ),
              TextFormField(
                 initialValue:_initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                 validator: (value){
                  if(value.isEmpty){
                  return 'Please enter a price.';
                  }
                  if(double.tryParse(value)==null){// i use try parse so that it would not fail like parse if value is null
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value)<=0){
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                 },
                  onSaved:(value){
                    _editedProduct=Product(title:_editedProduct.title,
                    price:double.parse(value),   //basically value is always string so we parse it to integer
                    description:_editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                     id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    );
                  },
              ),
              TextFormField(
                 initialValue:_initValues['description'],//we can't use this method in imageUrl because there we have use controller
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                 validator: (value){
                  if(value.isEmpty){
                  return 'Please enter a description.';
                  }
                 if(value.length<10){
                   return 'Should be atleaast 10 character long';
                  }
                  return null;
                 },
                  onSaved:(value){
                    _editedProduct=Product(title:_editedProduct.title,
                    price:_editedProduct.price,   //basically value is always string so we parse it to integer
                    description:value,
                    imageUrl: _editedProduct.imageUrl,
                     id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,

                    );
                  },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode:_imageUrlFocusNode,
                        onSaved:(value){
                    _editedProduct=Product(title:_editedProduct.title,
                    price:_editedProduct.price,   //basically value is always string so we parse it to integer
                    description:_editedProduct.description,
                    imageUrl: value,
                     id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,

                    );
                  },
                   validator: (value){
                
                    if(value.isEmpty){
                      return 'Please enter an image URL';
                      }
                      if(!value.startsWith('http')&&!value.startsWith('https')){
                        return 'Please enter a valid URL.';
                      }
                      if(!value.endsWith('.png')&&!value.endsWith('.jpg')&&!value.endsWith('jpeg')){
                        return 'Please enter a valid URL';
                      }
                  return null;
                   },
                      onFieldSubmitted: (_){
                        _saveForm();    //on field widget accept string in argument but we are not acceptin any stering in saveform function so its sytax become like this
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
