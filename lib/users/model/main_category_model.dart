class MainCategory
{
  int? main_category_id;
  String? main_category_name;
  String? image;

  MainCategory({
    this.main_category_id,
    this.main_category_name,
    this.image,

  });

  factory MainCategory.fromJson(Map<String,dynamic> json)=>MainCategory(
    main_category_id:int.parse(json["main_category_id"]),
    main_category_name:json["main_category_name"],
    image:json['image'],

  );


}