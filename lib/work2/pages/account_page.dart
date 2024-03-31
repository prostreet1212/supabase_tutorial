import 'package:flutter/material.dart';
import 'package:supabase_tutorial/work2/components/avatar.dart';
import 'package:supabase_tutorial/work2/main2.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  String? _imageUrl;


  @override
  void initState() {
    super.initState();
    _getInitialProfile();
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _getInitialProfile() async{
    final userId = supabase.auth.currentUser!.id;
    final data =
    await supabase.from('profiles').select().eq('id', userId).single();

    setState(() {
      _usernameController.text = (data['username'] ?? '') as String;
      _websiteController.text = (data['website'] ?? '') as String;
      _imageUrl = data['avatar_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          Avatar(imageUrl:_imageUrl,
              onUpload: (imageUrl)async{
            setState(() {
              _imageUrl=imageUrl;
            });
            final userId = supabase.auth.currentUser!.id;
            await supabase.from('profiles').update({'avatar_url':imageUrl}).eq('id', userId);
              }),
          SizedBox(height: 12,),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(labelText: 'User Name'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(labelText: 'Website'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: ()async{
              final userName=_usernameController.text.trim();
              final website=_websiteController.text.trim();
              final userId=supabase.auth.currentUser!.id;
              await supabase.from('profiles').update({
                'username':userName,
                'website':website,
              }).eq('id', userId);
              if(mounted){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Your data has been saved')),
                );
              }
            },
            child: Text('Save' ),
          ),
          const SizedBox(height: 18),
          TextButton(onPressed: null, child: const Text('Sign Out')),
        ],
      ),
    );
  }
}
