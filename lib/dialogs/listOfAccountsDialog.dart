import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:turtle_ninja/models/credentials.dart';
import 'package:turtle_ninja/models/userCredentials.dart';
import 'package:turtle_ninja/shared/AccountTile.dart';
import '../models/secureStorage.dart';
import '../services/auth.dart';
import '../services/localAuthApi.dart';


class ListOfAccountDialog extends StatefulWidget {
  late String title;
  late Function toggleBiometric;
 // late String description;

  ListOfAccountDialog({required this.title,required this.toggleBiometric});

  @override
  State<ListOfAccountDialog> createState() => _ListOfAccountDialogState();
}

class _ListOfAccountDialogState extends State<ListOfAccountDialog> {
  int selectedValue=-1;
  void changeSelectedValue(int value){
    setState((){
      selectedValue=value;
    });

  }
  final AuthService _auth = GetIt.I.get<AuthService>();
  bool error=false;
  void refresh(){
    setState((){
    });
  }
  final SecureStorage secureStorage = SecureStorage();
  String? stringofUsersCredentials;
  late List<UserCredentials> listofUsersCredentials=[];
  @override
  void initState() {
    super.initState();
  }

  Future<UserCredentials> getSecureStorage() async {
    stringofUsersCredentials = await secureStorage.readSecureData('credentials');
    if(stringofUsersCredentials != null){
      listofUsersCredentials = UserCredentials.decode(stringofUsersCredentials!);
      return listofUsersCredentials[0];
    }
    return UserCredentials(email: '', password: '');
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) {

    return Container(
      height: 1300.h,
      decoration: BoxDecoration(
        color: Colors.green[300],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(24.r)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/fingerprint.jpg',
                    fit: BoxFit.cover,
                    height: 300.w,
                    width: 300.w,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Text(
            widget.title,
            style: TextStyle(
                fontSize: 40.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16.h,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                FutureBuilder<UserCredentials>(
                    future: getSecureStorage(),
                    builder: (context, AsyncSnapshot<UserCredentials> snapshot) {
                      if (snapshot.hasData) {
                        if(stringofUsersCredentials!=null) {
                          return Container(
                            height: 400.h,
                            width: 1000.w,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:listofUsersCredentials.length ,
                                itemBuilder: (context,index){
                                  return AccountTile(userCredentials: listofUsersCredentials,refresh: refresh,index: index,selectedValue: selectedValue,changeSelectedValue: changeSelectedValue,);
                                },
                              ),
                          );
                        } else{
                          return Text('');
                        }
                      } else {
                        return Text('');
                      }
                    }
                ),





              ],
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(

                onPressed: () async {
                  if( GetIt.I.get<SingletonUser>().userCredentials.email==''){
                   setState((){
                     error=true;
                   });
                  }else{
                    final isAuthenticated = await LocalAuthApi.authenticate();
                    if (isAuthenticated) {
                      widget.toggleBiometric();
                      Navigator.pop(context);
                      dynamic result = await _auth.signInWithEmailAndPassword(GetIt.I.get<SingletonUser>().userCredentials.email,GetIt.I.get<SingletonUser>().userCredentials.password);
                    }
                  }


                },
                child: Text("Login",style: TextStyle(color: Colors.white),),
            ),
            if(error)
              Text("choose an account", style: TextStyle(color: Colors.red),)
          ],
        )
        ],
      ),
    );
  }
}
