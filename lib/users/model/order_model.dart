
class Order
{
  int? order_id;
  int? user_id;
 // String? selectedItems;
  String? deliverySystem;
  String? paymentSystem;
  String? note;
  double? totalAmount;
  String? image;
  String? status;
  DateTime? dateTime;
  String? shipmentAddress;
  String? name;
  String? phoneNumber;
  String? itemsdata;

  Order({
    this.order_id,
    this.user_id,
   // this.selectedItems,
    this.deliverySystem,
    this.paymentSystem,
    this.note,
    this.totalAmount,
    this.image,
    this.status,
    this.dateTime,
    this.shipmentAddress,
    this.name,
    this.phoneNumber,
    this.itemsdata,
  });

  factory Order.fromJson(Map<String, dynamic> json)=>Order(
    order_id : int.parse(json["order_id"]),
    user_id : int.parse(json["user_id"]),
    //selectedItems : json["selectedItems"],
    deliverySystem : json["deliverySystem"],
    paymentSystem : json["paymentSystem"],
    note : json["note"],
    totalAmount : double.parse(json["totalAmount"]),
    image : json["image"],
    status :json["status"],
    dateTime : DateTime.parse(json["dateTime"]),
    shipmentAddress : json["shipmentAddress"],
    name : json["name"],
    phoneNumber : json["phoneNumber"],
    itemsdata: json["itemsdata"],
  );


  Map<String,dynamic>toJson(String imageSelectedBase64)=>
      {
        "order_id" : order_id.toString(),
        "user_id" : user_id.toString(),
       // "selectedItems" : selectedItems,
        "deliverySystem" : deliverySystem,
        "paymentSystem" : paymentSystem,
        "note" : note,
        "totalAmount" : totalAmount!.toStringAsFixed(2),
        "image" : image,
        "status" :status,
        "shipmentAddress" : shipmentAddress,
        "name" : name,
        "phoneNumber" : phoneNumber,
        "imageFile":imageSelectedBase64,
        "itemsdata":itemsdata,
      };


}