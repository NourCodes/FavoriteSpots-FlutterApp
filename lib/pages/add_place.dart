import 'package:favorite_spots_app/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final controller = TextEditingController();

  void addPlace() {
    final place = controller.text;
    if (place.isEmpty) {
      return;
    }
    ref.read(placeProvider.notifier).addPlace(place);
    Navigator.of(context).pop();
  }

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
              onPressed: () => addPlace(),
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
