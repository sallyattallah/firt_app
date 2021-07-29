import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sally_shop_app/layout/cubit/cubit.dart';
import 'package:sally_shop_app/layout/cubit/states.dart';
//import 'package:sally_shop_app/layout/news_app/cubit/cubit.dart';
//import 'package:sally_shop_app/layout/news_app/news_layout.dart';
//import 'package:sally_shop_app/layout/shop_app/cubit/cubit.dart';
import 'package:sally_shop_app/layout/shop_layout.dart';
import 'package:sally_shop_app/modules/login/shop_login_screen.dart';
import 'package:sally_shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:sally_shop_app/modules/social_app/social_login/social_login_screen.dart';
import 'package:sally_shop_app/shared/bloc_observer.dart';
import 'package:sally_shop_app/shared/components/constants.dart';
//import 'package:sally_shop_app/shared/cubit/cubit.dart';
//import 'package:sally_shop_app/shared/cubit/states.dart';
import 'package:sally_shop_app/shared/network/local/cache_helper.dart';
import 'package:sally_shop_app/shared/network/remote/dio_helper.dart';
import 'package:sally_shop_app/shared/styles/themes.dart';

void main() async {
  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();


  Widget widget;

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  if(onBoarding != null)
  {
    if(token != null) widget = ShopLayout();
    else widget = ShopLoginScreen();
  } else
  {
    widget = OnBoardingScreen();
  }
  runApp(MyApp(

  ));
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget
{
  // constructor
  // build

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
        BlocProvider(
        create: (context) => ShopCubit()..getHomeData()..getCategoriesData()..getFavorites()..getUserInfo()

    ),
    ],
    child: BlocConsumer<ShopCubit, ShopStates>(
    listener: (context, state) {},
    builder: (context, state) {
    return MaterialApp(

      home: SocialLoginScreen(),
    );
    },
    ),
    );
  }
}