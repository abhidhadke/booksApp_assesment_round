import 'package:books_app/network/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  ApiWorker api = ApiWorker();
  RxList filteredItems = [].obs;
  List originalList = [];

  @override
  void initState() {
    callData();
    super.initState();
  }

  Future<void> callData()async{
  await api.getData();
  filteredItems.clear();
  filteredItems.addAll(api.list);
  filteredItems.refresh();
  debugPrint('call data count: ${filteredItems.length}');
  }


  void _filterList(String query) {
    debugPrint('filter');
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, show the original list
        filteredItems = api.list;
      } else {
        filteredItems = api.list
            .where((item) => item['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList().obs;
      }
    });
    filteredItems.refresh();
    debugPrint('count: ${filteredItems.length}');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BooksApp', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 10),
            child: Text("List View Search", style: TextStyle(fontWeight: FontWeight.bold), ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5)
              ),
              child: TextField(
                onChanged: _filterList,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Search',
                  hintText: 'Enter search term',
                  prefixIcon: Icon(Icons.search, color: Colors.blue[400],),
                  suffix: Padding(
                      padding: EdgeInsets.only(right: 10,left: 10,),
                      child: Icon(Icons.highlight_remove, color: Colors.blue[400],))
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() => RefreshIndicator(
              onRefresh: callData,
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (BuildContext context, int index) {
                  Map object = filteredItems[index];
                  String name = "${object['firstName']} ${object['lastName']}";
                  object['name'] = name;
                  String email = object['email'];
                  String city = object['city'];
                  return ListTile(
                    title: Text(name),
                    subtitle: Text('$email \ncity: $city'),
                    leading: CircleAvatar(backgroundColor: Colors.blue[400],child: Text(name[0]),),
                  );
                },)),
            ))
        ],
      ),
    );
  }
}
