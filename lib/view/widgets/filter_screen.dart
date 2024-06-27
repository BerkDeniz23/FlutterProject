import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final String selectedCity;
  final String selectedType;
  final int selectedMinCapacity;
  final int selectedMaxCapacity;
  final int selectedMinPrice;
  final int selectedMaxPrice;
  final Function(String, String, int, int, int, int) onApplyFilter;

  const FilterScreen({
    required this.selectedCity,
    required this.selectedType,
    required this.selectedMinCapacity,
    required this.selectedMaxCapacity,
    required this.selectedMaxPrice,
    required this.selectedMinPrice,
    required this.onApplyFilter,
    Key? key,
  }) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late String selectedCity;
  late String selectedType;
  late int selectedMinCapacity;
  late int selectedMaxCapacity;
  late int selectedMinPrice;
  late int selectedMaxPrice;

  @override
  void initState() {
    super.initState();
    selectedCity = widget.selectedCity;
    selectedType = widget.selectedType;
    selectedMinCapacity = widget.selectedMinCapacity;
    selectedMaxCapacity = widget.selectedMaxCapacity;
    selectedMinPrice = widget.selectedMinPrice;
    selectedMaxPrice = widget.selectedMaxPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrele'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onApplyFilter(selectedCity, selectedType, selectedMinCapacity,
                  selectedMaxCapacity, selectedMinPrice, selectedMaxPrice);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Şehir'),
              trailing: DropdownButton<String>(
                value: selectedCity,
                items: <String>['All', 'İstanbul', 'Ankara', 'İzmir', 'Kocaeli', 'Edirne']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Kategori'),
              trailing: DropdownButton<String>(
                value: selectedType,
                items: <String>[
                  'All',
                  'Düğün Salonu',
                  'Kır Düğünü Mekanı',
                  'Otel',
                  'Davet Alanları',
                  'Sosyal Tesis'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Min Kapasite'),
              trailing: DropdownButton<int>(
                value: selectedMinCapacity,
                items: List.generate(21, (index) => index * 50)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedMinCapacity = newValue!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Max Kapasite'),
              trailing: DropdownButton<int>(
                value: selectedMaxCapacity,
                items: List.generate(21, (index) => (index + 1) * 50)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedMaxCapacity = newValue!;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onApplyFilter(selectedCity, selectedType, selectedMinCapacity,
                    selectedMaxCapacity, selectedMinPrice, selectedMaxPrice);
                Navigator.pop(context);
              },
              child: const Text('Filtreyi Uygula'),
            ),
          ],
        ),
      ),
    );
  }
}
