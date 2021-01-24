import 'package:flutter/material.dart';
import 'package:loyalbee/models/DataBase.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Message.dart';

class Messages with ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages {
    return [..._messages];
  }

  Future<void> retrieveMessage() async{
    final _userData = await DBProvider.db.getUsers();

    final newUser= Map<String , String >.from(_userData);

    final token = newUser['token'];


    final url = 'https://beel-6e17a.firebaseio.com/Messages.json?auth=$token';

    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Message> messageInformation = [];

    extractedData.forEach((messageId , messageData){
      messageInformation.add(Message(
          id: messageId,
        title: messageData['title'],
        content: messageData['content'],
      ));

    });
    _messages = messageInformation.toList();
    notifyListeners();

  }

  Message findById(String id) {
    return _messages.firstWhere((messageS) => messageS.id == id);
  }

}
