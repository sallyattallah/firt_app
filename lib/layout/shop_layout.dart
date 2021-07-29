import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sally_shop_app/layout/cubit/cubit.dart';
import 'package:sally_shop_app/layout/cubit/states.dart';

import 'package:sally_shop_app/modules/login/shop_login_screen.dart';
import 'package:sally_shop_app/modules/search/saerch_screen.dart';

import 'package:sally_shop_app/shared/components/components.dart';
import 'package:sally_shop_app/shared/network/local/cache_helper.dart';

class ShopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ShopCubit, ShopStates>(
    listener: (context, state) {},
    builder: (context, state) {
    var cubit = ShopCubit.get(context);
        return Scaffold(

          appBar: AppBar(
            title: Text(
              'Salla',
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  navigateTo(context, SearchScreen(),);
                },
              ),
            ],
    ),

          body:cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.grey,
              elevation: 20.0,

            onTap: (int index){
              cubit.changeBottomNavigationBar(index);
            },
              currentIndex: cubit.currentIndex,
             items:
              [BottomNavigationBarItem(
               icon:Icon(Icons.home),
               label:'Home'
             ),
               BottomNavigationBarItem(
                   icon:Icon(Icons.apps),
                   label:'categories'
               ),
               BottomNavigationBarItem(
                   icon:Icon(Icons.favorite),
                   label:' Favorites'
               ),
               BottomNavigationBarItem(
                   icon:Icon(Icons.settings),
                   label:'Setting'
               )]
          ),






      );
    },
    );
  }
}
