

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turtle_ninja/helpers/dialogHelper.dart';
import 'package:turtle_ninja/models/credentials.dart';
import 'package:turtle_ninja/pages/loading.dart';
import 'package:turtle_ninja/services/auth.dart';
import 'package:turtle_ninja/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/secureStorage.dart';
import '../../models/userCredentials.dart';
import '../../services/localAuthApi.dart';
import '../../shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  final Function togglenotAuth;
  late Function toggleBiometric;

  SignIn({required this.toggleView,required this.togglenotAuth,required this.toggleBiometric});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = GetIt.I.get<AuthService>();
  final _formKey = GlobalKey<FormState>();
  bool loading=false;
  final storage = FlutterSecureStorage();
  final SecureStorage secureStorage = SecureStorage();
  late String? secureEmail;
  late String? securePassword;
  late bool showBiometric = false;
  String? stringofUsersCredentials;
  late List<UserCredentials> listofUsersCredentials=[];

  @override
  void initState(){
    super.initState();
    //getSecureStorage();

  }
  Future<UserCredentials> getSecureStorage() async {
    stringofUsersCredentials = await secureStorage.readSecureData('credentials');
    if(stringofUsersCredentials != null){
      listofUsersCredentials = UserCredentials.decode(stringofUsersCredentials!);
      return listofUsersCredentials[0];
    }
    return UserCredentials(email: '', password: '');
  }

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading?Loader():Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        title: Text('Sign In'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 50.0.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0.h,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Enter an email";
                  }
                  return null;
                },
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(
                height: 20.0.h,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val!.length < 6
                    ? 'Enter a password 6+ characters long'
                    : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(
                height: 20.0.h,
              ),
              ElevatedButton(
                onPressed: () async {

                  widget.togglenotAuth();
                  if (_formKey.currentState!.validate()) {
                    setState((){
                      loading=true;
                    });
                    // storage.write(key: "email", value: email);
                    // storage.write(key: 'password', value: password);

                    Credentials.email=email;
                    Credentials.password=password;


                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {

                      setState(() {
                        error = "could not sign in with those credentials";
                        loading=false;
                      });
                    }
                  }
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow[600],
                ),
              ),
              SizedBox(height: 20.0.h,),
              Text(
                error,
                style: TextStyle(color: Colors.red,fontSize: 14.0.sp),
              ),
              SizedBox(height: 20.0.h,),



            FutureBuilder<UserCredentials>(
                future: getSecureStorage(),
                builder: (context, AsyncSnapshot<UserCredentials> snapshot) {
                  if (snapshot.hasData) {
                    if(stringofUsersCredentials!=null)
                    return buildAuthenticate(context);
                    else{
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
      ),
    );
  }

  Widget buildAuthenticate(BuildContext context) => buildButton(
    text: 'Authenticate',
    icon: Icons.lock_open,
    onClicked: () async {
      await DialogHelper.listOfAccounts(context, "Choose an account to login in with",widget.toggleBiometric);
      setState((){});
    },
  );

  Widget buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(100.h),
          primary: Colors.green[800],
        ),
        icon: Icon(icon, size: 60.h),
        label: Text(
          text,
          style: TextStyle(fontSize: 40.sp),
        ),
        onPressed: onClicked,

      );
}
