import 'package:get/get.dart';

class ItemDetailsController extends GetxController
{
  RxInt _quantityItem =1.obs;
  RxBool _isFavorite =false.obs;

  int get quantity => _quantityItem.value;
  bool get isFavorite => _isFavorite.value;

  setQuantityItem(int quantityOfItem)
  {
    _quantityItem.value = quantityOfItem ;
  }
  setisFavorite(bool isFavorite)
  {
    _isFavorite.value =isFavorite;
   // print(isFavorite);
  }
}