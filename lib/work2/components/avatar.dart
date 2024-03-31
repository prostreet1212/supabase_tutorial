import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_tutorial/work2/main2.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key? key, this.imageUrl, required this.onUpload})
      : super(key: key);

  final String? imageUrl;

  final void Function(String imageUrl) onUpload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey,
                  child: Center(
                    child: Text('No Image'),
                  ),
                ),
        ),
        SizedBox(
          height: 12,
        ),
        ElevatedButton(
            onPressed: () async {
              ImagePicker picker = ImagePicker();
              XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image == null) {
                return;
              }
              final imageExtension=image.path.split('.').last;
              final imagBytes = await image.readAsBytes();
              final userId = supabase.auth.currentUser!.id;
              final imagePath = '/$userId/profile';
              await supabase.storage
                  .from('profiles')
                  .uploadBinary(imagePath, imagBytes,
              fileOptions: FileOptions(
                upsert: true,contentType: 'image/$imageExtension'
              ));

              String imageUrl =
                  supabase.storage.from('profiles').getPublicUrl(imagePath);
              imageUrl=Uri.parse(imageUrl).replace(queryParameters: {
                't':DateTime.now().millisecondsSinceEpoch.toString()
              }).toString();

              onUpload(imageUrl);
            },
            child: Text('Upload'))
      ],
    );
  }
}
