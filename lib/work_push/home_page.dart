import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_tutorial/work_push/widgets/item_list.dart';

import 'main3.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((event)async {
      if(event.event==AuthChangeEvent.signedIn){
        await FirebaseMessaging.instance.requestPermission();
        await FirebaseMessaging.instance.getAPNSToken();
        final fcmToken=await  FirebaseMessaging.instance.getToken();
        if(fcmToken!=null){
await _setFcmToken(fcmToken);
        }
      }
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((event)async {
      await _setFcmToken(event);
    });
  }

  Future<void> _setFcmToken(String fcmToken)async{
    final userId=supabase.auth.currentUser?.id;
    if(userId!=null){
      await supabase.from('push_profiles').upsert(
          {
            'id':userId,
            'fcm_token':fcmToken,
          }
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home',),
      actions: [
        IconButton(
            onPressed: ()async{
              await supabase.auth.signOut();
            },
            icon: Icon(Icons.logout))
      ],),
      body:StreamBuilder<AuthState>(
        stream: supabase.auth.onAuthStateChange,
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.data?.session==null){
            //return AuthentificationWidget();
          }
          return ItemList();
        },
      )

    );
  }
}
