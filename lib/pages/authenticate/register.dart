

import 'package:turtle_ninja/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/credentials.dart';
import '../../services/auth.dart';
import '../../shared/constants.dart';


class Register extends StatefulWidget {

  final Function toggleView;
  final Function toggleRegistered;
  Register({required this.toggleView,required this.toggleRegistered});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = GetIt.I.get<AuthService>();
  final _formKey = GlobalKey<FormState>();
  bool loading=false;

  //text field state
  String email='';
  String password='';
  String error='';



  @override
  Widget build(BuildContext context) {
    return loading?Loader():Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        elevation: 0.0,
        title: Text('Sign Up'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: (){
              widget.toggleView();

            },
            icon:Icon(Icons.person),
            label: Text('Sign In',style: TextStyle(color: Colors.white),),
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
                decoration:textInputDecoration.copyWith(hintText: 'Email'),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Enter an email";
                  }
                  return null;
                },
                onChanged: (val) {
                  setState((){
                    email=val;
                  });
                },
              ),
              SizedBox(
                height: 20.0.h,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val!.length < 6 ? 'Enter a password 6+ characters long':null,
                obscureText: true,
                onChanged: (val) {
                  setState((){
                    password=val;
                  });
                },
              ),
              SizedBox(
                height: 20.0.h,
              ),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    setState((){
                      loading=true;
                    });
                    widget.toggleRegistered();
                    Credentials.email=email;
                    dynamic result=await _auth.registerWithEmailAndPassword(email, password);
                    if(result==null){
                      setState((){
                        error="please supply a valid email";
                        loading=false;
                      });
                    }

                  }

                },
                child: Text(
                  'Register',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
