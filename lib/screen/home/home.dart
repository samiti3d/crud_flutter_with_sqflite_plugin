import 'package:flutter/material.dart';
import 'package:sqflite_flutter/helper/dbhelper.dart';
import 'package:sqflite_flutter/models/car.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper.instance;

  //controller used in insert operation UI
  TextEditingController nameController = TextEditingController();
  TextEditingController milesController = TextEditingController();

  TextEditingController idDeleteController = TextEditingController();

  List<Car> cars = [];
  List<Car> carsByName = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              text: "Insert",
            ),
            Tab(
              text: "View",
            ),
            Tab(
              text: "Delete",
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Car Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: milesController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Car Miles',
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text('Insert Car Details'),
                  onPressed: () {
                    String name = nameController.text;
                    int miles = int.parse(milesController.text);
                    _insert(name, miles);
                  },
                ),
              ]),
            ),
            Container(
              child: ListView.builder(
                  itemCount: cars.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == cars.length) {
                      return ElevatedButton(
                        child: const Text('Refresh'),
                        onPressed: () {
                          setState(() {
                            _queryAll();
                          });
                        },
                      );
                    }

                    return SizedBox(
                      height: 40,
                      child: Center(
                        child: Text(
                          '[${cars[index].id}] - ${cars[index].name}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  }),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: idDeleteController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Car id',
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        int id = int.parse(idDeleteController.text);
                        _delete(id);
                        idDeleteController.clear();
                      },
                      child: Text('Delete')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$message"),
    ));
  }

  void _insert(name, miles) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnMiles: miles
    };
    Car car = Car.fromMap(row);
    final id = await dbHelper.insert(car);
    _showMessage('inserted row id: $id');
  }

  void _queryAll() async {
    final allRows = await dbHelper.queryAllRows();
    cars.clear();
    allRows.forEach((row) {
      cars.add(Car.fromMapDB(row));
    });
    _showMessage('Query done.');
  }

  void _delete(id) async {
    final rowsDeleted = await dbHelper.delete(id);
    _showMessage('Query done. $rowsDeleted');
  }
}
