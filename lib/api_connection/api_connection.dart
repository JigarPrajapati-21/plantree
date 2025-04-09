class API
{
    static const hostConnect="http://10.0.2.2/planTree_API";
    static const hostConnectUser="$hostConnect/user";

    //signup user
    static const validateEmail="$hostConnectUser/validate_email.php";
    static const signUp="$hostConnectUser/signup.php";
    static const login="$hostConnectUser/login.php";

    static const trending="$hostConnect/plant/trending.php";
    static const all="$hostConnect/plant/all.php";

    //cart
    static const addToCart="$hostConnect/cart/add.php";
    static const getCartList="$hostConnect/cart/read.php";
    static const deleteSelectedItemsFromCartList="$hostConnect/cart/delete.php";
    static const updateItemInCartList="$hostConnect/cart/update.php";

    //favorite
    static const validateFavorite="$hostConnect/favorite/validate_favorite.php";
    static const addFavorite="$hostConnect/favorite/add.php";
    static const deleteFavorite="$hostConnect/favorite/delete.php";
    static const readFavorite="$hostConnect/favorite/read.php";

    //all item
    static const getAllItems="$hostConnect/plant/all_items.php";

    static const searchItems="$hostConnect/items/search.php";

    //category
    static const mainCategory="$hostConnect/category/main_category.php";
    static const subCategory="$hostConnect/category/sub_category.php";
    static const itemsOfSubCategory="$hostConnect/category/items_of_sub_category.php";

    //order
    static const addOrder="$hostConnect/order/add_1.php";
    static const readOrders="$hostConnect/order/read.php";
    static const getOrderItems="$hostConnect/order/getOrderItems.php";
    static const updateStatus="$hostConnect/order/update_status.php";
    static const readHistory="$hostConnect/order/read_histoy.php";

    //admin
    static const adminLogin="$hostConnect/admin/admin_login.php";
    static const adminData="$hostConnect/admin/admin_data.php";
    static const getNewOrder="$hostConnect/admin/read.php";

    static const addMainCategory="$hostConnect/admin/add_main_category.php";
    static const addSubCategory="$hostConnect/admin/add_sub_category.php";
    static const addItem="$hostConnect/admin/add_item.php";



}


// class API
// {
//     static const hostConnect="http://10.0.2.2:8080/planTree_API";
//     static const hostConnectUser="$hostConnect/user";
//
//     //signup user
//     static const validateEmail="$hostConnectUser/validate_email.php";
//     static const signUp="$hostConnectUser/signup.php";
//     static const login="$hostConnectUser/login.php";
//
//     static const trending="http://10.0.2.2:8080/planTree_API/plant/trending.php";
//     static const all="http://10.0.2.2:8080/planTree_API/plant/all.php";
//
//     //cart
//     static const addToCart="http://10.0.2.2:8080/planTree_API/cart/add.php";
//     static const getCartList="http://10.0.2.2:8080/planTree_API/cart/read.php";
//     static const deleteSelectedItemsFromCartList="http://10.0.2.2:8080/planTree_API/cart/delete.php";
//     static const updateItemInCartList="http://10.0.2.2:8080/planTree_API/cart/update.php";
//
//     //favorite
//     static const validateFavorite="http://10.0.2.2:8080/planTree_API/favorite/validate_favorite.php";
//     static const addFavorite="http://10.0.2.2:8080/planTree_API/favorite/add.php";
//     static const deleteFavorite="http://10.0.2.2:8080/planTree_API/favorite/delete.php";
//     static const readFavorite="http://10.0.2.2:8080/planTree_API/favorite/read.php";
//
//     //all item
//     static const getAllItems="http://10.0.2.2:8080/planTree_API/plant/all_items.php";
//
//     static const searchItems="http://10.0.2.2:8080/planTree_API/items/search.php";
//
//     //category
//     static const mainCategory="http://10.0.2.2:8080/planTree_API/category/main_category.php";
//     static const subCategory="http://10.0.2.2:8080/planTree_API/category/sub_category.php";
//     static const itemsOfSubCategory="http://10.0.2.2:8080/planTree_API/category/items_of_sub_category.php";
//
//     //order
//     static const addOrder="http://10.0.2.2:8080/planTree_API/order/add_1.php";
//     static const readOrders="http://10.0.2.2:8080/planTree_API/order/read.php";
//     static const getOrderItems="http://10.0.2.2:8080/planTree_API/order/getOrderItems.php";
//     static const updateStatus="http://10.0.2.2:8080/planTree_API/order/update_status.php";
//     static const readHistory="http://10.0.2.2:8080/planTree_API/order/read_histoy.php";
//
//     //admin
//     static const adminLogin="http://10.0.2.2:8080/planTree_API/admin/admin_login.php";
//     static const adminData="http://10.0.2.2:8080/planTree_API/admin/admin_data.php";
//     static const getNewOrder="http://10.0.2.2:8080/planTree_API/admin/read.php";
//
//     static const addMainCategory="http://10.0.2.2:8080/planTree_API/admin/add_main_category.php";
//     static const addSubCategory="http://10.0.2.2:8080/planTree_API/admin/add_sub_category.php";
//     static const addItem="http://10.0.2.2:8080/planTree_API/admin/add_item.php";
//
//
//
// }