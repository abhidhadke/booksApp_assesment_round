import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApiWorker{
RxList list = [].obs;

  Future<int> getData() async{
    try{
      String requestId = "643074200605c500112e0902";
      String url = "https://api.thenotary.app/lead/getLeads";
      var urlParse = Uri.parse(url);
      http.Response response =
      await http.post(urlParse, body: {
        "notaryId" : requestId
      });
      Map map = jsonDecode(response.body);
      list.clear();
      list.addAll(map['leads']);
      list.refresh();
      debugPrint('list count: ${list.length}');

      return 1;
    }
    catch(e, s){
      debugPrint("$e \n$s");
      return 0;
    }
  }
}