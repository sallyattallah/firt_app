import 'package:sally_shop_app/models/shop_app/login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialState extends ShopLoginStates {}

class ShopLoginLoadingState extends ShopLoginStates {}

class ShopLoginSuccessState extends ShopLoginStates
{
  final ShopLoginModel loginModel;

  ShopLoginSuccessState(this.loginModel);
}

class ShopLoginErrorState extends ShopLoginStates
{
  final String error;

  ShopLoginErrorState(this.error);
}

class ShopChangePasswordVisibilityState extends ShopLoginStates {}


class ShopUpdateLoadingState extends ShopLoginStates {}

class ShopUpdateUserSuccessState extends ShopLoginStates
{
  final ShopLoginModel loginModel;

  ShopUpdateUserSuccessState(this.loginModel);
}

class ShopUpdateUserErrorState extends ShopLoginStates {
}
