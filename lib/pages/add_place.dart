import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add a New Place",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.black,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: controller,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                hintText: 'Enter your Favorite spot',
                hintStyle: TextStyle(
                  color: Colors.grey.shade300,
                ),
                labelText: 'Title',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                elevation: 0.6,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    3,
                  ),
                ),
              ),
              onPressed: () => () {},
              label: const Text(
                "Add",
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
