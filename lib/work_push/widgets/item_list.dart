import 'package:flutter/material.dart';
import 'package:supabase_tutorial/work2/main2.dart';


class ItemList extends StatelessWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context,index){
          final name='Item $index';
          final price=index*100;
          return ListTile(
            title: Text(name),
            subtitle: Text('\$$price.00'),
            trailing: TextButton(
              onPressed: ()async{
                await supabase.from('orders').insert(
                  {
                    'name':name,
                    'price':price,
                  }
                );
              },
              child: Text('Purchase'),
            ),
          );
        });
  }
}
