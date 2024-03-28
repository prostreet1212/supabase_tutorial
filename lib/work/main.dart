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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Countries',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _notesStream=Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My notes'),
      ),
      body: StreamBuilder<List<Map<String,dynamic>>>(
        stream: _notesStream,
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          List<Map<String,dynamic>> notes=snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
              itemBuilder: (context,index){
              return ListTile(
                title: Text(notes[index]['body']),
              );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(
              context: context,
              builder: ((context){
                return SimpleDialog(
                  title: Text('Add a Note'),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    TextFormField(
                      onFieldSubmitted: (value)async{
                        await Supabase.instance.client
                            .from('notes').insert({'body':value});
                    },)
                  ],
                );
              }));
        },
      ),
    );
  }
}
