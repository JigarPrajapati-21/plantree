class SubCategory
{
  int? sub_category_id;
  int? main_category_id;
  String? sub_category_name;
  String? image;

  SubCategory({
    this.sub_category_id,
    this.main_category_id,
    this.sub_category_name,
    this.image,

  });

  factory SubCategory.fromJson(Map<String,dynamic> json)=>SubCategory(
    sub_category_id:int.parse(json["sub_category_id"]),
    main_category_id:int.parse(json["main_category_id"]),
    sub_category_name:json["sub_category_name"],
    image:json['image'],

  );


}