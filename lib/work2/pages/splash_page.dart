import 'package:flutter/material.dart';
import 'package:supabase_tutorial/work2/main2.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async{
    await Future.delayed(Duration.zero);
    final session=supabase.auth.currentSession;
    if(!mounted) return;
    if(session!=null){
      Navigator.of(context).pushReplacementNamed('/account');
    }else{
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
