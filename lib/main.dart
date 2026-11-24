import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CarTablePage(),
    );
  }
}

class Car {
  final String carMake;
  final String model;
  final double price;

  const Car({
    required this.carMake,
    required this.model,
    required this.price,
  });
}

class CarTablePage extends StatefulWidget {
  const CarTablePage({super.key});

  @override
  State<CarTablePage> createState() => _CarTablePageState();
}

class _CarTablePageState extends State<CarTablePage> {
  static const List<Car> _originalCars = [
    Car(carMake: 'Honda', model: '2021', price: 35000.0),
    Car(carMake: 'Toyota', model: '2011', price: 6000.0),
    Car(carMake: 'BMW', model: '2010', price: 9000.0),
  ];

  final List<Car> _cars = List<Car>.of(_originalCars);

  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _sort<T extends Comparable<T>>(
    T Function(Car car) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      _cars.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);

        return ascending
            ? aValue.compareTo(bValue)
            : bValue.compareTo(aValue);
      });

      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void _resetSorting() {
    setState(() {
      _cars
        ..clear()
        ..addAll(_originalCars);

      _sortColumnIndex = null;
      _sortAscending = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DataTable Sorting'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _sortColumnIndex == null ? null : _resetSorting,
              child: const Text('Reset Sorting'),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columns: [
                DataColumn(
                  label: const Text('Car Make'),
                  onSort: (index, ascending) {
                    _sort<String>((car) => car.carMake, index, ascending);
                  },
                ),
                DataColumn(
                  label: const Text('Model'),
                  onSort: (index, ascending) {
                    _sort<String>((car) => car.model, index, ascending);
                  },
                ),
                DataColumn(
                  label: const Text('Price'),
                  numeric: true,
                  onSort: (index, ascending) {
                    _sort<num>((car) => car.price, index, ascending);
                  },
                ),
              ],
              rows: _cars.map((car) {
                return DataRow(
                  cells: [
                    DataCell(Text(car.carMake)),
                    DataCell(Text(car.model)),
                    DataCell(Text(car.price.toStringAsFixed(2))),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}