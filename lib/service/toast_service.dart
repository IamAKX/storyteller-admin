import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static ToastService instance = ToastService();

  ToastService();

  void showError(String _message) {
    Fluttertoast.showToast(
        msg: _message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showSna(String _message) {
    Fluttertoast.showToast(
        msg: _message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.amber,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  void showSuccess(String _message) {
    Fluttertoast.showToast(
        msg: _message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}