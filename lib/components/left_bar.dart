import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mcdo_ui/models/item-category.dart';

class LeftBar extends StatelessWidget {
  final List<ItemCategory> categories;
  final Function(ItemCategory) onCategorySelected;

  const LeftBar({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 80, left: 0, right: 10, bottom: 10), // Adjust top padding here
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 390,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: Center(
              child: SizedBox(
                height: 130,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          constraints: const BoxConstraints(maxWidth: 95, maxHeight: 95),
                          child: Image.memory(
                            categories[index].categoryImage as Uint8List,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            categories[index].itemCategoryName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    onCategorySelected(categories[index]);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
