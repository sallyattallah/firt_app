import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sally_shop_app/models/social_app/social_user_model.dart';
import 'package:sally_shop_app/modules/social_app/social_register/cubit/states.dart';


class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  //ShopLoginModel loginModel;

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  })
  {
    emit(SocialRegisterLoadingState());
   FirebaseAuth.instance.createUserWithEmailAndPassword
     ( email: email,
       password: password
   ).then((value) {
     print(value.user.email);
     print(value.user.uid);
     userCreate(name: name, email: email, phone: phone, uId: value.user.uid);
     emit(SocialRegisterSuccessState());
   }).catchError((error){
     emit(SocialRegisterErrorState(error.toString()));
    });

  }

void userCreate({@required String name,
  @required String email,
  @required String phone,
  @required String uId}){

  SocialUserModel model = SocialUserModel(
    name:name,
    phone: phone,
    email: email,
    uId: uId
  );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap()).then((value) {
          emit(SocialCreateUserSuccessState());
    })
    .catchError((error){
      emit(SocialCreateUserErrorState(error.toString()));
  });

}

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(SocialRegisterChangePasswordVisibilityState());
  }
}
