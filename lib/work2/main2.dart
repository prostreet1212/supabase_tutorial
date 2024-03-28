import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cgzdpcqdsjaiuuqxontb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnemRwY3Fkc2phaXV1cXhvbnRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE2MTc5MTUsImV4cCI6MjAyNzE5MzkxNX0.wNcTJ7iUG8c5sCeL6jOg0Qs5VWF89NJeqUyLYjnhPv0',
  );
  runApp(const MyApp());
}

final supabase=Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //home: HomePage(),
    );
  }
}