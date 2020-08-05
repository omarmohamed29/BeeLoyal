import 'package:flutter/material.dart';

    class Offer with ChangeNotifier{
    final String id;
    final String title;
    final String description;
    final int amount;
    final DateTime dueDate;

    Offer({
      this.id,
      this.title,
      this.description,
      this.amount,
      this.dueDate
    });
    }


