import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedCategory = "Men";
  String selectedSize = "S";
  String selectedColor = "Black";
  RangeValues priceRange = const RangeValues(150, 300);

  final categories = ["All", "Women", "Men", "Children", "Kids"];
  final sizes = ["XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL"];
  final colors = ["Black", "White", "Red", "Grey", "Blue", "Yellow", "Pink"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          "Filter",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Category"),
            _buildOptionWrap(
              items: categories,
              selectedItem: selectedCategory,
              onSelected: (val) => setState(() => selectedCategory = val),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle("Size"),
            _buildOptionWrap(
              items: sizes,
              selectedItem: selectedSize,
              onSelected: (val) => setState(() => selectedSize = val),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle("Price Range"),
            RangeSlider(
              values: priceRange,
              min: 50,
              max: 350,
              divisions: 6,
              activeColor: Colors.deepOrangeAccent,
              inactiveColor: Colors.grey.shade300,
              onChanged: (values) {
                setState(() => priceRange = values);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("\$50"),
                Text("\$100"),
                Text("\$150"),
                Text("\$200"),
                Text("\$250"),
                Text("\$300"),
                Text("\$350"),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionTitle("Color"),
            _buildOptionWrap(
              items: colors,
              selectedItem: selectedColor,
              onSelected: (val) => setState(() => selectedColor = val),
            ),
            const Spacer(),

            // Filter button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Filter",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildOptionWrap({
    required List<String> items,
    required String selectedItem,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final selected = item == selectedItem;
        return GestureDetector(
          onTap: () => onSelected(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? Colors.deepOrangeAccent : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              item,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
