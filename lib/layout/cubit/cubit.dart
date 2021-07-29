import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sally_shop_app/layout/cubit/states.dart';
import 'package:sally_shop_app/models/shop_app/categories_model.dart';
import 'package:sally_shop_app/models/shop_app/change_favorites_model.dart';
import 'package:sally_shop_app/models/shop_app/favorites_model.dart';
import 'package:sally_shop_app/models/shop_app/home_model.dart';
import 'package:sally_shop_app/models/shop_app/login_model.dart';
import 'package:sally_shop_app/modules/categories/categories_screen.dart';
import 'package:sally_shop_app/modules/favorites/favorites_screen.dart';
import 'package:sally_shop_app/modules/login/cubit/states.dart';
import 'package:sally_shop_app/modules/products/products_screen.dart';
import 'package:sally_shop_app/modules/settings/settings.dart';
import 'package:sally_shop_app/shared/components/constants.dart';
import 'package:sally_shop_app/shared/network/remote/dio_helper.dart';
import 'package:sally_shop_app/shared/network/end_points.dart';

class ShopCubit extends Cubit <ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context)=>BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> bottomScreens =[
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),

  ];
void changeBottomNavigationBar(int index){
  currentIndex=index;
  emit(ShopChangeBottomNavState());
}
  HomeModel homeModel;
  Map<int,bool> favorites = {} ; 
void getHomeData(){
  emit(ShopLoadingHomeDataState());
  DioHelper.getData(
      url: HOME,
      token: token).then(
          (value)
      {
        homeModel=HomeModel.fromJson(value.data);
        //print(homeModel.data.banners[0].image);
       // print('ssss');
       // print(homeModel.status);
        homeModel.data.products.forEach((element) { 
          favorites.addAll({
            element.id:element.inFavorites
          });
        });

emit(ShopSuccessHomeDataState());
          }).catchError((error){
            emit(ShopErrorHomeDataState());
            print(error.toString());});
}

  CategoriesModel categoriesModel;

void getCategoriesData(){

    DioHelper.getData(
        url: GET_CATEGORIES,
        ).then(
            (value)
        {
          categoriesModel=CategoriesModel.fromJson(value.data);

          emit(ShopSuccessCategoriesDataState());
        }).catchError((error){
      emit(ShopErrorCategoriesDataState());
      print(error.toString());});
  }

  ChangeFavoritesModel changeFavoritesModel;

  void changeFavorites(int productId){
    favorites[productId]=!favorites[productId];
    emit(ShopChangeFavoritesState());
  DioHelper.postData(
      url: FAVORITES,
      data:{
        'product_id' :productId
      },
     token:token,
  ).then((value)  {
    changeFavoritesModel=ChangeFavoritesModel.fromJson(value.data);
    print(value.data);
    if(!changeFavoritesModel.status){
      favorites[productId]=!favorites[productId];

    }else{
      getFavorites();
    }
    emit(ShopSuccessChangeFavoritesState(changeFavoritesModel));
  }).catchError((error){
  emit(ShopErrorChangeFavoritesState());}
  );
  }

  FavoritesModel favoritesModel;
  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      //printFullText(value.data.toString());

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }



  ShopLoginModel userModel;
  void getUserInfo() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel.data.name);

      emit(ShopSuccessUserDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    @required String name,
    @required String email,
    @required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel.data.name);

      emit(ShopSuccessUpdateUserState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}