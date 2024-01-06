import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageContainer extends StatefulWidget {
  final void Function (File image) onSelectedImage;
  const ImageContainer({super.key, required this.onSelectedImage});

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  File? selectedImage;
  void takePic() async {
    ImagePicker picker = ImagePicker();
    final imagePicked =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (imagePicked == null) {
      return;
    }
    setState(() {
      selectedImage = File(imagePicked.path);
    });
    widget.onSelectedImage(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = TextButton.icon(
      onPressed: takePic,
      icon: const Icon(Icons.camera),
      label: const Text("Take Picture"),
    );
    if (selectedImage != null) {
      screen = GestureDetector(
        onTap: takePic,
          child: Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        width: 1,
      )),
      height: 200,
      width: double.infinity,
      child: screen,
    );
  }
}
