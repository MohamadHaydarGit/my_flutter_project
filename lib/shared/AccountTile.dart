import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:turtle_ninja/models/secureStorage.dart';
import 'package:turtle_ninja/models/userCredentials.dart';

import '../services/auth.dart';
import '../services/localAuthApi.dart';

class AccountTile extends StatefulWidget {
  late List<UserCredentials> userCredentials;
  late Function refresh;
  late int index;
  late int selectedValue;
  late Function changeSelectedValue;
  AccountTile({required this.userCredentials, required this.refresh,required this.index,required this.selectedValue, required this.changeSelectedValue});

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {



  String? stringofUsersCredentials;
  late List<UserCredentials> listofUsersCredentials=[];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 4.0),
      child: Card(
        child: RadioListTile<int>(
          value: widget.index,
          groupValue: widget.selectedValue ,

          onChanged: (value) async {
              widget.changeSelectedValue(value);
              GetIt.I.get<SingletonUser>().userCredentials.email=widget.userCredentials[widget.index].email;
              GetIt.I.get<SingletonUser>().userCredentials.password=widget.userCredentials[widget.index].password;
              widget.refresh();


          // sign in here with fingerprint
          //   final isAuthenticated = await LocalAuthApi.authenticate();
          //   if (isAuthenticated) {
          //     Navigator.pop(context);
          //     dynamic result = await _auth.signInWithEmailAndPassword(widget.userCredentials.email,widget.userCredentials.password!);
          //   }
          },
          activeColor: Colors.green[800],
          title:Text(widget.userCredentials[widget.index].email,style: TextStyle(fontSize: 35.sp),),
         // leading: Icon(Icons.person,color: Colors.green[800],),
          secondary: TextButton(
            onPressed: () async{
              //delete this account from biometric authentication
              SecureStorage secureStorage=SecureStorage();
              stringofUsersCredentials = await secureStorage.readSecureData('credentials');
            if(stringofUsersCredentials != null) {
              listofUsersCredentials =
                  UserCredentials.decode(stringofUsersCredentials!);
              listofUsersCredentials.removeWhere((element) => element.email==widget.userCredentials[widget.index].email);
              await secureStorage.writeSecureData('credentials', UserCredentials.encode(listofUsersCredentials));
              GetIt.I.get<SingletonUser>().userCredentials=UserCredentials(email: '', password: '');
              widget.changeSelectedValue(-1);
              widget.refresh();
              if(listofUsersCredentials.isEmpty){
                Navigator.pop(context);
              }
            }





            },
            child: Icon(Icons.delete, color:Colors.red,),
          ),

        ),
      ),
    );;
  }
}
