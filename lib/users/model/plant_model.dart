class Plants
{
  int? item_id;
  String? name;
  int? sub_category_id;
  double? rating;
  List<String>? tags;
  double? price;
  String? description;
  String? image;
 // String? created_date;

  Plants({
     this.item_id,
     this.name,
     this.sub_category_id,
     this.rating,
     this.tags,
     this.price,
     this.description,
     this.image,
    // this.created_date,
});

  factory Plants.fromJson(Map<String,dynamic> json)=>Plants(
       item_id:int.parse(json["item_id"]),
       name:json["name"],
       sub_category_id:int.parse(json["sub_category_id"]),
       rating:double.parse(json["rating"]),
       tags:json["tags"].toString().split(","),
       price:double.parse(json["price"]),
       description:json['description'],
       image:json['image'],
      // created_date:json["created_date"],
  );

  @override
  String toString(){
    //print('userId: $userId, userName: $userName, userContact: $userContact,userEmail: $userEmail,userPassword: $userPassword');
   // print('Plants{item_id: $item_id, name: $name, sub_category_id: $sub_category_id,rating: $rating,tags: $tags, price: $price, description:$description,image:$image,created_date:created_date}');
print("wwwwwwwwww");
    return 'Plants{item_id: $item_id, name: $name, sub_category_id: $sub_category_id,rating: $rating,tags: $tags, price: $price, description:$description,image:$image}';
  }

}