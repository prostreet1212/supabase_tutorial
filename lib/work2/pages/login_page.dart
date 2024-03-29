import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_tutorial/work2/main2.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

   final TextEditingController _emailController = TextEditingController();
   late final StreamSubscription<AuthState> _authSubscription;

   @override
  void initState() {
    super.initState();
    _emailController.text='prostreet1212@gmail.com';
    _authSubscription=supabase.auth.onAuthStateChange.listen((event) {
      final session=event.session;
      if(session!=null){
        Navigator.of(context).pushReplacementNamed('/account');
      }
    });
  }


   @override
  void dispose() {
     _emailController.dispose();
     _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 12,),
          ElevatedButton(
            child: Text('Login'),
              onPressed: ()async{
              try{
                final email=_emailController.text.trim();
                await supabase.auth.signInWithOtp(email: email,
                    emailRedirectTo:'io.supabase.flutterquickstart://login-callback/' );
                if(mounted){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Check your inbox')),
                  );
                }
              }on AuthException catch(error){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.message),
                    backgroundColor: Theme.of(context).colorScheme.error,),
                );
              }
              catch(e){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ошибка: ${e.toString()}'),
                  //SnackBar(content: Text('Error occured, please retry.'),
                  backgroundColor: Theme.of(context).colorScheme.error,),
                );
              }



              },
              )
        ],
      ),
    );
  }
}
