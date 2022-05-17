
import 'package:chat/services/auth.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  //Key
  final _formKey = GlobalKey<FormState>();

  //Text states:
  String email = '';
  String password = '';

  //error
  String error = '';

  //loading
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() :Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/loginBg.jpg'),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB( 50,50,50,0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20,),
                      TextFormField(
                        style:const TextStyle(
                          color: Colors.white
                        ),
                        decoration: textInputDecoration.copyWith(hintText: 'e-mail',
                        border: InputBorder.none
                        ),
                        validator: (val) => val!.isEmpty ? 'enter an email ID' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        style: const TextStyle(
                            color: Colors.white
                        ),
                        decoration: textInputDecoration.copyWith(hintText: 'password'),
                        validator: (val) => val!.length <6 ? 'Password should be at least of 6 chars' : null,
                        obscureText: true,
                        onChanged: (val){
                          setState(() => password = val);
                        },
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                          onPressed: () async {
                            if(_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic user = await _auth.signInWithEmailAndPassword(email, password);
                              if(user == null){
                                setState(() {
                                  error = 'Invalid login credentials';
                                  loading = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                          ),
                          child: const Text('Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                          onPressed: (){
                            widget.toggleView();
                          },
                          child: const Text('Not registered yet? Click here',
                            style: TextStyle(
                                color: Colors.deepPurple
                            ),)
                      ),
                      Text(error,
                        style: const TextStyle(
                            color: Colors.red
                        ),)
                    ]
                )
            )
        ),
      ),
    );
  }
}
