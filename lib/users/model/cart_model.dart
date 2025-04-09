import 'dart:convert';

class Cart
{
  int? cart_id;
  int? user_id;
  int? item_id;
  int? quantity;
  String? name;
  double? rating;
  List<String>?tags;
  double? price;
  String? description;
  String? image;

  Cart({
    this.cart_id,
    this.user_id,
    this.item_id,
    this.quantity,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.description,
    this.image,
  });

  factory Cart.fromJson(Map<String,dynamic>json) => Cart(
    cart_id: int.parse(json['cart_id']),
    user_id: int.parse(json['user_id']),
    item_id: int.parse(json['item_id']),
    quantity: int.parse(json['quantity']),
    name: json['name'],
    rating: double.parse(json['rating']),
    price: double.parse(json['price']),
    description: json['description'],
    image: json['image'],
  );


  @override
  String toString(){
    return 'Cart{cart_id: $cart_id, user_id: $user_id, item_id: $item_id,quantity: $quantity,name: $name, rating: $rating, price:$price, description:$description,image:$image}';
  }

  Map<String, dynamic> toMap() {
    return {
      'cart_id': cart_id,
      'user_id': user_id,
      'item_id': item_id,
      'quantity': quantity,
      'name': name,
      'rating': rating,
      'price':price,
      'description':description,
      'image':image
    };

  }



}